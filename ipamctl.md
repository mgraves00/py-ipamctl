# IPAMCTL

## Synopsis

	ipamctl [-fh] [-c file] <action> <resource> [resource values ... ]

## Description

The ipamctl utilitiy allows interaction with the IPAM database.  Resource records may be added updated or deleted.  If the database does not exist it will be created and the default schema installed.  Records can have required values and options.  If a record is missing a required option and error will be returned with the required options listed.

The options are as follows:

	-c		Specifiy an alternat config file to read
	-h		Help screen
	-f		force action to be completed. Used when deleting a domain or record that has that has other records tied to tie

## Actions

	add		Add a domain or record to the database
	backup	Export all domains and records from the database into a file or stdout.  This can then be used by the restore command to re-import all the records into a clean database.
	del		Delete a domain or record in the database.  Can used the -f flag if the domain or record has other records tied to it.  This will also delete those records.
	export	Export a domain into a specific name name daemon format
	show	Show the domains or records in the database
	restore	Import domains and recors from backup file.  Restore will not overwrite existing data.  It can only succeed on a new database.
	upd		Update a domain or record in the database	

## Resources
	domain		Operate on a domain or subdomain.  Can be used with commands: add, upd, del, show, export.  Valid export formats are: bind, nsd, unbound
	record		Operate on a record.  Can be used with commands: add, upd, del.
	network		Operate on a record.  Can be used with command: show
	address		Operate on a record.  Can be used with command: show
	database	Operate on the database.  Can be used with commands: backup, restore

## Examples

Create domain

	ipamctl add domain example.com server1.example.com email:no.example.com refresh:20 retry:30 expire:40 ncache:50

Create a record

	ipamctl add record ns1.example.com A 1.1.1.1

Show a record

	ipamctl show record ns1.example.com

Show all records for a domain

	ipamctl show record *.exammple.com

Update a record.  The id of the record will be shown in the output of the 'show' command

	ipamctl upd record ns1.example.com A 1.1.1.2 id:20

Delete a record

	ipamctl del record ns2.example.com id:20

Export a domain to nsd format

	ipamctl export domain example.com nsd

Backup a database to file.bak

	ipamctl backup database file.bak

Restore a database from file.bak

	ipamctl restore database file.bak


## NOTES

### Database
The database makes an attept at requiring necessary field for specific records it does not validate the values of those records.  If bad or incorrect data for a record is added to the datbase it will be output or exported and may prevent a zone from loading.  A lint program for the appropiate name server software should be used to validate the output of the export before it replaces known good zone files.

### DNSSEC Records
DNSSEC records RREC NECS3 DNSKEY are not stored in the database. Due to the requirements of DNSSEC storing those records wouldn't make much sense, because they need to be generated based upon the current records in the datbase.  The only record the can be stored is the DS record for deligation.  An external program should be used to sign a domain once it's been exported.

### Zone Serial Number
The zone serial number is generated from the current date/time when the zone is exported.

## Also See
	ipam.ini(5), ipamd(7)
