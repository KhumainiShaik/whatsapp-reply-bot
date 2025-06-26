from googleapiclient import discovery
import google.auth

def stop_vm(request):
    credentials, project = google.auth.default()
    compute = discovery.build('compute', 'v1', credentials=credentials)

    zone = 'us-central1-f'
    instance = 'whatsapp-reply-bot'

    compute.instances().stop(project=project, zone=zone, instance=instance).execute()
    return 'VM stop triggered'