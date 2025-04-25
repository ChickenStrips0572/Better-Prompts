# Better-Prompts
The module fixes issues with referencing Proximity Prompts and provides an organized way to manage prompts being "listened to."

## Key features

### Listing to prompts
:IsListeningtoPrompt("PromptName")

checks if the system is listening to a specific prompt if it is it returns "true" but if not returns "false"

### Adding Prompts
:Add("PromptName" , "Module Script") 

Adds a promt to be listened for by the system

### Removing Prompts
:Removing("PromptName")

removes a prompt that the system is listening to