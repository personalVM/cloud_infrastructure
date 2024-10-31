export BILLING_ACC="01F0C7-9A2082-488963"
export PROJECT_INFRA_NAME="personalvm"
export PROJECT_INFRA_ID="${PROJECT_INFRA_NAME}1"
gcloud projects create $PROJECT_INFRA_ID --name=$PROJECT_INFRA_NAME --labels=owner=guilhermeviegas,environment=dev --enable-cloud-apis
gcloud beta billing projects link $PROJECT_INFRA_ID --billing-account=$BILLING_ACC
gcloud config set project $PROJECT_INFRA_ID
# cd Documents/09-personalVM/

gcloud services enable compute.googleapis.com --project=$PROJECT_INFRA_ID
gcloud services enable dns.googleapis.com --project=$PROJECT_INFRA_ID
gcloud services enable iam.googleapis.com --project=$PROJECT_INFRA_ID
gcloud services enable cloudresourcemanager.googleapis.com --project=$PROJECT_INFRA_ID

# echo "# cloud_infrastructure" >> README.md
# git init
# git config --global init.defaultBranch main
# git add README.md
# git commit -m "first commit"
# git branch -M main
# git remote add origin git@github.com:personalVM/cloud_infrastructure.git
# git push -u origin main

git clone ------ personalVM:cloud_infrastructure

terraform init 
terraform apply

terraform state list
terraform state show module.network.google_dns_record_set.tf_a_record




gcloud compute ssh personalvm-computeinstance --zone us-west4-b



--

echo "# personal_rstudio" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:personalVM/personal_rstudio.git
git push -u origin main






--
Extra:


terraform state rm <resource_address>
terraform state pull # Detailed description of the resources available
git config --list
git config user.name
nslookup guigo.dev.br
find . -type f -exec sed -i 's/old_term/new_term/g' {} +


sudo docker run -d -p 8787:8787 --name rstudio -e ROOT=true -e USER=rstudio -e PASSWORD=rstudio --user root rocker/geospatial


---




docker build -t personal_rstudio -f rstudio.Dockerfile .
docker run -d -v $(pwd):/home/rstudio personal_rstudio



docker-compose up --build




sudo docker run -d -e PASSWORD=minhasenha -p 8787:8787 -v /home/guilhermeviegas1993/:/home/rstudio/ --name=personal_rstudio_ctn "$img_id"
sudo docker run -d -e PASSWORD=minhasenha -p 8787:8787 -v ~/:/home/rstudio/ --name=personal_rstudio_ctn "$img_id"
sudo docker run -d -e PASSWORD=minhasenha -p 8787:8787 --name=personal_rstudio_ctn "$img_id"


sudo docker inspect personal_rstudio  | grep -i 'password'