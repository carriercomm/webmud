module.exports =
  enter: ->
    # cant be sure that there weren't any changes to the user record while logging in, so refresh the latest saved record
    query = @mud.db.User.findOne name: @name

    query.exec (err, foundUser) =>
      if err
        return console.log "DB Err: " + err

      if @mud.userLoggedIn @name
        return @changeState 'checkLoggedIn'

      if foundUser
        @loggedIn = true
        @record = foundUser
        @entity = @record.entity
        @settings = @record.settings
        @writelnp "*{249}Welcome, *{255}#{@name}*{249}!", "*{255}#{@name} has entered the realm.*{249}"
        @mud.broadcast "*{255}#{@name} has entered the realm.*{249}", this
        @createEntity()
        @changeState 'main'
      else
        # should not get to this point, since the record should be in the database
        @writeln "*{226}There was problem loading your data, please hit refresh."
        @changeState 'goodbye'