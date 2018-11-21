# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
      #app was built with Sinatra and used the Corneal gem.
- [x] Use ActiveRecord for storing information in a database
      #ActiveRecord was utilized and all data is stored in a database.
- [x] Include more than one model class (e.g. User, Post, Category)
      #app includes a User model and a Wine model.
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts)
      #User has_many Wines
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User)
      #Wine belongs_to User
- [x] Include user accounts with unique login attribute (username or email)
      #User can create an account with a username, and log in with same username.
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
      #Wine data can be created, viewed, updated, and deleted.
- [x] Ensure that users can't modify content created by other users
      #Users are prevented from modifying content by other users because edit and delete links only appear in individual user show pages, and the routes prevent URL hacking.
- [x] Include user input validations
      #User input is validated as present in the controller.
- [ ] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
      #Could not get flash messages to work. Would love to implement this in the review.
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
