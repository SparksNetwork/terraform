Make sure your AWS variables are set up before running

```
brew install terraform
terraform plan -out=terraform.plan
```

review review review

```
terraform apply terraform.plan
git add .
git commit -m "Stuff I've changed"
git push
```


