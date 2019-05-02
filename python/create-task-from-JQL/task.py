import json
from jira import JIRA


issue_dict = {
        'project': {'key': 'project_key'},
        'description': 'your_description',
        'issuetype': {'name': 'issutype_name'},
        'assignee': {'name': 'assignee_name'},
        'reporter': {'name': 'reporter_name'},
        'labels': ['label']
        }

jira = JIRA(basic_auth=('login', 'pass'), options={'server': 'http://example.com'})
for issue in jira.search_issues('Your JQL here'):
     #print('{}: {}: {}: {}'.format(issue.key, issue.fields.summary, issue.fields.customfield_10002, issue.fields.components))
     existingComponents = []
     for component in issue.fields.components:
       existingComponents.append({"name" : component.name})
       #print existingComponents
     existingVersion = []
     for version in issue.fields.fixVersions:
       existingVersion.append({"name" : version.name})
       #print existingVersion
     issue_dict['summary'] = issue.fields.summary
     issue_dict['customfield_10002'] = issue.fields.customfield_10002
     issue_dict['components'] = existingComponents
     issue_dict['priority'] = { 'id': issue.fields.priority.id, 'name': issue.fields.priority.name }
     issue_dict['fixVersions'] = existingVersion
     
     print issue_dict
     new_issue = jira.create_issue(fields=issue_dict)
 #link issues, if need it
     jira.create_issue_link(
        type="includes",
        inwardIssue=new_issue.key,
        outwardIssue=issue.key
        )
     print (new_issue.key)
