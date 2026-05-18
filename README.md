# Travel Memo App

A Flutter mobile application that allows users to record and manage their travel memories using full CRUD operations.

## Features

**Create** : Add a new travel memory with place name, location, distance, image, and personal memory.

![Add screen Screenshot](assets/images/AddMemory.png)

**Read** : View all travel memories in a clean card-based home screen.

![Home screen Screenshot](assets/images/Read.png)

**Update** : Edit any existing travel memory.

![Edit screen Screenshot](assets/images/EditMemory.png)

**Delete** : Remove a memory with a confirmation dialog.

![Delete screen Screenshot](assets/images/DeleteMemory.png)

## Error Handling

- Network error message with retry button

![Network Error screenshot](assets/images/NetworkError.png)

- Image error placeholders

![Image Error screenshot](assets/images/ImageError.png)

- Empty state when no memos exist
- Form validation on all input fields
- Success and failure snackbars for all actions

## Loading states

- Loading spinner while fetching data

![Loading screenshot](assets/images/HomeLoading.png)

-This app uses [JSONPlaceholder](https://jsonplaceholder.typicode.com)
as the public REST API.
-It Use the latest Provider state management solution for state management and the http package for making network requests.
