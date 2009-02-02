# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_phd.git_session',
  :secret      => '751bf0f38eb4088c8e40fce06a0b5d6eb7464dae662ba7a5282b644c390ce7ff4619265789f16c1a41f9171603a891fc76e2d2dabfa75fb452a5c8eda923a044'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
