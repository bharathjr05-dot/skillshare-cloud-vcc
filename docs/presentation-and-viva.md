# Presentation and viva outline: Public PaaS

## Suggested 6-slide presentation

1. **Project goal:** SkillShare Hub lets users list skills and request sessions.
2. **Application features:** registration/login, personal skill management, community listings, and session requests.
3. **PaaS architecture:** browser → Render public web service → Docker container → Tomcat/JSP application.
4. **Build and deployment:** Maven packages a WAR; Docker builds and runs Tomcat; Render deploys from the Git repository.
5. **Live demonstration:** show the public HTTPS URL, sign in/register, browse skills, add a skill, and submit a session request.
6. **Results and limitations:** rubric coverage, free instance sleeping, and demo database resetting on restart.

## Demo sequence

1. Open the public Render URL and show HTTPS.
2. Register the first demo user, show the dashboard, and add a skill.
3. Sign out and register a second demo user.
4. Browse the first user's community skill and submit a session request.
5. Show the Render service page with its Free plan and successful deploy log.
6. Explain that Render sleeps after inactivity, so a first request can take about a minute. Demo records are held in H2 memory and reset after process restart.

## Likely viva questions

- **What is a Public PaaS?** A provider-hosted app platform that exposes a public deployment endpoint and manages much of the runtime and deployment infrastructure.
- **What does Render manage?** It builds the container from the repository, runs the web service, assigns a public domain, terminates HTTPS, and handles deploy lifecycle.
- **What does the project provide?** JSP app code, Maven packaging configuration, a Dockerfile, and Render Blueprint configuration.
- **How is the app deployed?** Maven packages a WAR; the Docker build copies it into Tomcat; Render builds and runs the Dockerfile from the repository.
- **What is the public URL?** Render assigns an HTTPS `onrender.com` subdomain to the web service.
- **Why can the first page load be slow?** Free web services sleep after a period without inbound traffic and need time to start again.
- **Why do demo records disappear?** This no-cost setup uses an in-memory database and no persistent disk or database service.
- **How could persistence be added?** Attach a persistent datastore, update the application connection configuration, and account for its ongoing cost.
