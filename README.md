### Working with:
 * 1.19.0               Microsoft.Graph

### Some extra information:
* https://learn.microsoft.com/en-us/graph/api/relatedcontact-update?view=graph-rest-beta&tabs=http
* https://learn.microsoft.com/en-us/graph/api/resources/relatedcontact?view=graph-rest-1.0
* https://learn.microsoft.com/en-us/powershell/microsoftgraph/get-started?view=graph-powershell-1.0

![GUI - parents](https://user-images.githubusercontent.com/113233490/211123292-a0d21d54-93b6-4ef5-9648-99877e2f0acf.PNG)


### edu_parents_gui.ps1

By executing this file, you will open a simple GUI. This will allow you to search for an edu user in your tenant by providing the email address. The tool will then search for the corresponding information of the related contacts of that user. You can adjust the information and then update it. Sometimes it can take a while before the adjustments become visible in the parents app.
! While testing I noticed the following: only when selecting "parent" as relationship made sure the related contacts were visible in the parents app in teams. Other relationship selections made the related contacts invisible in the app. I have not yet found out of this "work in progress" from Microsoft or a deliberate choice.
