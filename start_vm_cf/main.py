from googleapiclient import discovery
import google.auth

def start_vm(request):
    credentials, project = google.auth.default()
    compute = discovery.build('compute', 'v1', credentials=credentials)

    zone = 'us-central1-f'
    instance = 'whatsapp-reply-bot'

    compute.instances().start(project=project, zone=zone, instance=instance).execute()
    return 'VM start triggered'
