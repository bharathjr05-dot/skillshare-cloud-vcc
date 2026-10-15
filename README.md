# SkillShare Cloud — Public PaaS Project

This project turns the original SkillShare Hub into a class-ready public PaaS deployment. It keeps registration, login, skill listings, and session requests. It is packaged as a Java web app and deployed to Render using a Dockerfile and a public `onrender.com` URL.

## Rubric criterion

**Application Development and Deployment using Public PaaS:** develop the SkillShare web application, package it as a WAR, build and run it in a Tomcat container, deploy the container through Render, and demonstrate the live public URL and app flow.

## Architecture

```text
Browser -> HTTPS public Render URL -> Render Web Service -> Tomcat 9 -> JSP application
                                                           -> H2 in-memory demo database
```

Render provides Docker based web services with a public `onrender.com` domain. The included `render.yaml` requests the Free plan. The web service listens on Render's `PORT` environment variable.

## Local build

Requirements: Docker Desktop, or JDK 8+ and Maven 3.8+.

With Maven:

```powershell
mvn clean package
```

The WAR is generated at `target/skillshare-cloud-vcc-1.0.0.war`.

With Docker:

```powershell
docker build -t skillshare-cloud-vcc .
docker run --rm -p 10000:10000 skillshare-cloud-vcc
```

Open `http://localhost:10000` and register a demo account. New passwords use PBKDF2 hashes.

## Deploy to Render Free Web Service

1. Create a GitHub repository for this project and put the **contents** of `SkillShareCloudVCC` at the repository root. The root should contain `Dockerfile`, `render.yaml`, `pom.xml`, `WEB-INF`, and `WebContent`.
2. In Render, choose **New → Blueprint** and connect the repository. The included `render.yaml` defines a Docker web service named `skillshare-cloud-vcc` on the Free plan.
3. Review the Blueprint details and confirm it creates only the single free web service.
4. Wait for Render to finish the Docker build and deploy. Open the `onrender.com` URL assigned by Render.
5. Register two demo accounts. Use one account to add a skill; sign in with the other to browse it and submit a session request.
6. Capture screenshots of the service's Free plan/settings, successful deploy log, public URL, and working application flow for the report and viva.

Render supports Dockerfile based web services and expects a public service to listen on the configured `PORT`. Free web services can sleep after inactivity and take about a minute to wake. Their filesystem is temporary, so this app uses an in-memory H2 demo database: it resets when the process restarts or sleeps. User-created records are not durable. [Render Docker deployments](https://render.com/docs/docker) · [Render web services](https://render.com/docs/web-services) · [Render free plan limitations](https://render.com/docs/free).

## Presentation and viva

Use [docs/presentation-and-viva.md](docs/presentation-and-viva.md) for the slide outline and demo sequence.

## What to explain

- **PaaS:** Render manages the public web-service runtime and deployment lifecycle; the project supplies the application and Docker build instructions.
- **Application development:** Java/JSP app with account registration/login, skill CRUD, and session requests.
- **Build/deployment:** Maven packages the WAR, Docker packages Tomcat and the WAR, Render builds and publishes the service from the repository.
- **Public access:** Render supplies the `onrender.com` domain and HTTPS endpoint.
- **Free-tier behavior:** the free web service may sleep when idle and uses an ephemeral filesystem, so the demo database starts fresh after a restart.
