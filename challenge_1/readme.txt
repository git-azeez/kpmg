challenge:

Challenge #1
A 3 tier environment is a common setup. Use a tool of your choosing/familiarity create these resources. 
Please remember we will not be judging on the outcome but more on the approach, style and reproducibility.





1. I have created a sample architecture using draw.io
2. Services used are:
     1.GCE for Webservers (Presentation Tier)
     2.GAE for Application (Application Tier)
     3. Cloud sql for Database(Data Tier)
3. For Deploying the above components I have provided a simple terraform script 
4. In that script hardcoded all the names instead of defining as varaible as this is a simple architecture.
5. I have assumed that Application code is present in the GCS bucket.

Runing terraform script
1. terraform init
2. terraform plan
3. terraform apply


