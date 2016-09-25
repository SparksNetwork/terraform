# Terraform

## Install and setup
Make sure your AWS variables are set up before running

```
brew install terraform
terraform init -backend=s3 -backend-config="bucket=terraform.sparks.network" -backend-config="region=us-west-2" -backend-config="key=terraform.tfstate"
```

## Running:

Now you should be able to run the plan:

```
bin/plan
```

Review the changes and then if good:

```
bin/apply
git add .
git commit -m "Stuff I've changed"
git push
```

The helper script bin/plan produces a terraform.plan file and the script bin/apply applies it.
