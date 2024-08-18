# Project 4: Profile Service with Pub/Sub and Firestore

[https://github.com/SkillsMapper/skillsmapper/tree/main/profile-service](https://github.com/SkillsMapper/skillsmapper/tree/main/profile-service)

This chapter delves into the creation of a cloud native, event-driven microservice: the profile service.

This profile service will build and continuously update user profiles based on changing facts from the fact service.

The architecture will employ Google Pub/Sub for event notifications, Firestore as a serverless database to store user profiles, and Cloud Run for hosting the service.
