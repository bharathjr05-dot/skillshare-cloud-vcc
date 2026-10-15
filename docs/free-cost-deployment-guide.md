# No-cost public PaaS deployment guide

This project targets Render's Free Web Service plan for the PaaS demonstration. Render can change free-plan limits; check the linked Render docs while deploying. The project avoids a paid database by using an in-memory H2 database. Demo changes reset when the free service sleeps or restarts.

## Steps

1. Install Git (or use GitHub Desktop) and create a GitHub repository for this project.
2. Upload/push the **contents** of this folder so the repository root includes `Dockerfile`, `render.yaml`, `pom.xml`, `WEB-INF`, and `WebContent`.
3. Create/sign into Render and connect the GitHub repository.
4. Select **New → Blueprint**, choose the repository, and review the service shown by `render.yaml`.
5. Check that the selected plan is **Free**, with one web service and no database, disk, load balancer, or other add-on.
6. Deploy. Render builds the WAR inside the Docker build, starts Tomcat, and assigns a public `onrender.com` URL.
7. Open the URL and demonstrate registration/login, adding a skill, and submitting a request. Take screenshots for the report.
8. Capture the repository files, Render build/deploy log, service plan, public URL, and working app screens.

## Free service behavior

Render free web services sleep after 15 minutes with no inbound traffic. First access after sleep may wait about a minute. The file system is ephemeral; the included H2 in-memory database resets when the process stops/restarts. This app treats its data as demo-only and requires no paid datastore. See [Render Free](https://render.com/docs/free), [Render web services](https://render.com/docs/web-services), and [Render Docker](https://render.com/docs/docker).

## Cost check

Before deployment, verify the service plan says **Free** and the Blueprint creates only this web service. Avoid paid compute, persistent disks, managed databases, and add-ons. Render's current docs describe free web-service instance-hour/bandwidth allowances, sleep behavior, and the lack of a persistent disk.
