# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_phdstudy_session',
  :secret => '1347e0a81fb02f95a17448eec9bd61ddff0f7c3f30f0ba0260045c961d862fcba6ce00ee91812f0d4596e4f83e56b41934cd6d161610aa7cd9b837483418a6da'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
