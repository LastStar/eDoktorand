# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_phd.git_session',
  :secret      => 'c896d80d5b560f513ff85feedc4ce25f3605205c7080a3fc0b94cb058140627c7a26f9bfbe78d9948bdb0170591e5ea66cf7517a7d4faedaca0aae590e9d6acd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
