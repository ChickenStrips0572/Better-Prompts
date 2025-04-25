# Better-Prompts
The module fixes issues with referencing Proximity Prompts and provides an organized way to manage prompts being "listened to."

## Key features

### Listing to prompts
```bash
:IsListeningtoPrompt("PromptName")
```
checks if the system is listening to a specific prompt if it is it returns "true" but if not returns "false"

### Adding Prompts
```bash
:Add("PromptName" , "Module Script") 
```
Adds a prompt to be listened for by the system

### Removing Prompts
```bash
:Removing("PromptName")
```
removes a prompt that the system is listening to