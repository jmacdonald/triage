administrator = DatabaseUser.create({
  email: 'f1127013@rmqkr.net',
  username: 'dritchie',
  password: 'administrator',
  password_confirmation: 'administrator',
  name: 'Dennis Ritchie',
  role: 'administrator'
})

provider = DatabaseUser.create({
  email: 'f1126543@rmqkr.net',
  username: 'kthompson',
  password: 'provider',
  password_confirmation: 'provider',
  name: 'Ken Thompson',
  role: 'provider'
})

requester = DatabaseUser.create({
  email: 'f1127509@rmqkr.net',
  username: 'jmacdonald',
  password: 'requester',
  password_confirmation: 'requester',
  name: 'Jordan MacDonald',
  role: 'requester'
})

status = Status.create([{title: 'New', default: true}, {title: 'Assigned'}, {title: 'Closed', closed: true}])[1]
system = System.create(name: 'Triage')

request1, request2 = Request.create([{
  title: "Unable to sign in",
  description: 'I keep getting an "invalid username" message when trying to sign in.',
  requester: requester,
  system: system,
  severity: 'moderate',
  created_at: 6.hours.ago
},{
  title: "Can't see resolved requests",
  description: "I'd like to review previously resolved requests but I can't see them. Can someone please investigate?",
  requester: requester,
  system: system,
  status: status,
  assignee: provider,
  severity: 'minor',
  created_at: 2.hours.ago}])

Comment.create([{
  user: provider,
  request: request1,
  content: "The LDAP server was down for maintenance last night. @dritchie Is the LDAP server back up?",
  created_at: 5.hours.ago
},{
  user: administrator,
  request: request1,
  content: "Yes, it's back up and running. Jordan, please trying signing in again when you get a chance.",
  created_at: 4.hours.ago
},{
  user: requester,
  request: request1,
  content: "Thanks, I'll try again in a few minutes and will let you know what happens.",
  created_at: 2.hours.ago
},{
  user: provider,
  request: request2,
  content: "It looks like there's a bug that's causing this. Our development team is working on it as we speak. I'll let you know when it's resolved!",
  created_at: 1.hour.ago
}])
