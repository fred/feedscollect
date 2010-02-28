# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_feedscollect_session',
  :secret      => '7ec3b222653c63dffe099ddffcd317bafc1d450af2a4f1465e13136d0a6132437e6d73052887edac8fd38e7c9c663483399c8bd792e6d0745223efc01c259eeb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
