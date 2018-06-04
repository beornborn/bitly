## Decisions

design descisions and thought process were tuned to meet the next criterias:

no data about product

- who is the customer of this shortening link service
- what does this customer wants
- what are the goals
- what is the auditory
- how customer want to monetize this server

no data about

- candidates per position density
- expected salary
- correlation between quality of task performance and probability of receiving offer

- own experience as interviewer that often candidates that do more receive less points because more you do, more room for mistake

these considerations lead to decision to invest 20% of possible efforts to receive 80% of possible result
and lead the next decisions

- implement only core functionality
- implement this functionality as concise, clean, simple, object-oriented as possible
- don't write integration tests
- use well known and used before technologies


## Plans to improve

- research all well-known url shortener services to find best practices and choose your own business model and how you plan to compete
- create authentication and authorization
- frontend on react for better UX
- make response for user as fast as possible (create and redirect), that means make minimum required before sending response, and all other needed stuff do in background.
for this purpose can be implemented some queue mechanism and dedicated service to handle specific queues. for example aws queue and ec2, or sidekiq and ec2
- add integration tests
- setup ci
- add codequality tools like rubocop for ruby and flow/eslint for js
- add more features (use previous research to prioritize them and create milestones)
