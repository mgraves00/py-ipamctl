# IPAM.INI

## Description

The ipam.ini instrusts the ipamctl(5) and ipamd(5) 

## Section

### Server keys

	listen		ip address for the ipamd(5) server to listen on (required)
	port		port for the ipamd(5) server to listen on (required)
	apikey		API Key for the ipamd(5) server to use (required)
	user		user to change to with running as daemon (optional)

### Database keys

	type		type of datase connection. options: http, sqlite3
	server		ip of the server to connect to (only for type http)
	port		port for the server to connect to (only for type http)
	apikey		API Key for the communicating to the server (only for type http)
	path		path for the database file (only for type sqlite3)

## Examples

### Config for ipamctl with remote connection to ipamd
	[database]
	type=http
	server=127.0.0.1
	port=8000
	apikey=abc123

### Config for ipamctl with local db
	[database]
	type=sqlite3
	path=/var/db/ipam.db

### Config for ipamd
	[database]
	type=sqlite3
	path=/var/db/ipam.db

	[server]
	listen=127.0.0.1
	port=8000
	apikey=abc123
	user=_ipam

## Also See
	ipamctl(7), ipamd(7)

