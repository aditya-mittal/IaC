resource "octopusdeploy_feed" "github" {
  name = "GitHub Feed TF"  
  feed_type = "GitHub"
  feed_uri = "https://api.github.com"
  is_enhanced_mode = false
}

resource "octopusdeploy_feed" "feedz" {
  name = "Feedz Feed TF"  
  feed_type = "NuGet"
  feed_uri = "https://f.feedz.io/octopus-deploy-samples/octopus-samples/nuget/index.json"
}

resource "octopusdeploy_feed" "docker" {
  name = "Docker Feed TF"
  feed_type = "Docker"
  feed_uri = "https://index.docker.io"
  is_enhanced_mode = false
  download_attempts = 0
  download_retry_backoff_seconds = 0
}