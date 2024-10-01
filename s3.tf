AWS S3
Used for backup and storage of data
Allows to store files called objects in directories called buckets
Buckets are defined in a region level
Objects have a key which is the full path to the object 
Max object size is 5TB, If uploading more than 5Th, use multi-part upload
   
Security - json based policies
      
1. User based 
IAM policies - which API calls should be allowed for a specific user from IAM

2. Resource based
Bucket Policies - bucket wide rules, can be assigned from the s3 console. 
  Eg: Makes a s3 bucket public, allows cross account access
Object Access Control List (ACL) - finer grain security (can be disabled)
Bucket Access Control List (ACL) - can be disabled

An IAM principal can access an s3 object if the user IAM permission allows it or the resource policy allows it and there is no explicit denial.
