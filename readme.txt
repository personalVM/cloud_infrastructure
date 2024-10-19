export BILLING_ACC="01F0C7-9A2082-488963"
export PROJECT_INFRA_NAME="personalvm"
export PROJECT_INFRA_ID="${PROJECT_INFRA_NAME}1"
gcloud projects create $PROJECT_INFRA_ID --name=$PROJECT_INFRA_NAME --labels=owner=guilhermeviegas,environment=dev --enable-cloud-apis
gcloud beta billing projects link $PROJECT_INFRA_ID --billing-account=$BILLING_ACC
gcloud config set project $PROJECT_INFRA_ID
cd Documents/09-personalVM/

gcloud services enable compute.googleapis.com --project=$PROJECT_INFRA_ID
gcloud services enable dns.googleapis.com --project=$PROJECT_INFRA_ID
gcloud services enable iam.googleapis.com --project=$PROJECT_INFRA_ID
gcloud services enable cloudresourcemanager.googleapis.com --project=$PROJECT_INFRA_ID

echo "# cloud_infrastructure" >> README.md
git init
git config --global init.defaultBranch main
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:personalVM/cloud_infrastructure.git
git push -u origin main









