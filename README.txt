
Preparation:

Step 1: Create and publish Google Form for students to input responses. Give clear, simple instructions for how students should input responses. Be sure to set proper permissions (anyone with link).
Step 2: From form, create Google Sheet to hold responses. Be sure to set proper permissions (anyone with link).
Step 3. Create Shiny app. Use googlesheets4 pacakge to read sheet. Use gs4_deauth() function to allow read-only use without signing in. Use read_sheet() inside server function to allow updates as new data included.


In class:

Step 1. Share form with students, have them submit responses
Step 2. Run Shiny app, have fun!
Step 3. If app is published, share URL for students to have fun too!
