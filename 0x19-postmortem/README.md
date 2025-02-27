# Postmortem: Nginx nNot Listening on Port 80 (A Tragic Tale of a Missing Symlink)

![devops-debugging-headaches](image-asset.png)

# Issue Summary
## Duration of the Outage: The outage was detected at 09:20 hrs GMT and was resolved by 09:58 hrs GMT. A total downtime of 38 minutes. And yes I was confused.

## Impact: HTTP requests to the Nginx webserver failed. Every single one of them. (Obviously, in hindsight. I mean...)

## Root Cause: The default site configuration file was not activated because it was not linked in the sites-enabled directory. Lonely time for default config file. No symbolic links (no sneaky links either).

# Timeline (The Exciting Troubleshooting. Haha)
- 09:20 hrs GMT: Issue detected when a curl 0:80 request to the ALX Nginx server returned "curl: (7) Failed to connect to 0 port 80: Connection refused".
- 09:23 hrs GMT: Checked and confirmed that the Nginx server was not running (ps aux | grep nginx).
- 09:25 hrs GMT: Confirmed Nginx was installed on the system (nginx -v).
- 09:30 hrs GMT: Checked and confirmed Nginx configuration files had no errors (nginx -t).
- 09:40 hrs GMT: Checked to see if any service was listening on port 80, and no service was.
- 09:50 hrs GMT: Further investigation revealed that the default Nginx configuration file in sites-available directory had no symbolic link in sites-enabled directory.
- 09:55 hrs GMT: Created a symbolic link for the default site in sites-enabled directory.
- 09:58 hrs GMT: Restarted Nginx and sent a request to localhost on port 80 and confirmed the issue resolved, with the site back online. 

# Root Cause and Resolution
## Root Cause:
Nginx default site configuration file had not been linked to the sites-enabled directory, which was required to activate any site for the nginx server.

## Resolution (Gotcha!):
Upon realization of the root cause of this issue, a command was issued to create the symbolic for the deault site configuration file present in sites-available directory in the sites-enabled directory. This was required for the site to be activated. Nginx service was then restarted and the site came back online for HTTP requests.

# Corrective and Preventive Measures
## Improvements/Fixes:
Ensure Nginx is correctly configured and all active sites properly linked and activated whenever configuration changes or new installations are made. A script is written to be run to ensure consistency.
[The Script](postmortem_fix)

## Checklist (This is not happening twice. No!):
- Create and execute a script to create a symbolic link from the default Nginx site configuration in /etc/nginx/sites-available/ to /etc/nginx/sites-enabled/.
- Test the Nginx configuration for any errors (nginx -t).
- If test is successful, restart Nginx.
- Monitor to ensure Nginx is active, the site is active and listening on port 80. 
