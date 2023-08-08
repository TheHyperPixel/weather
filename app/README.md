# weather app

A basic weather app built over a period of 8 hours. 

As this was a coding challenge, time has been focused on:

- building a workable basic app
- demonstrating a clean architecture
- demonstrating repository interfaces and repository implementations
- demonstrating DTO's (manually written - not using code-gen)
- demonstrating Cubit (Bloc) logic 
- demonstrating error handling and exceptions
- demonstrating handing logic states with UI

Where time was not spent:

- designing UI
- adding in additional functionality that would improve the UI and UI
- adding in expected features that are common place within weather apps

## Tooling

- Flutter 3.10.5 • channel stable • https://github.com/flutter/flutter.git
- Framework • revision 796c8ef792 (8 weeks ago) • 2023-06-13 15:51:02 -0700
- Engine • revision 45f6e00911
- Tools • Dart 3.0.5 • DevTools 2.23.1

## Devices

This project has been tested with:
- iOS simulator running iOS 16.4
- Android simulator running Android 13

## Setup

The app implements a clean architecture folder structure whereby the project is split into three core layers:
- presentation: a folder containing code that helps render and present the UI. This includes sub fodlers such as generic common styling; screens; fragments; components; and extensions and utils to assist with formatting data for display.
- domain: a folder where logic, entities and repository interfaces live. 
- data: a folder where repository implementations, DTOs and other data centric files live. 

The notion around a clean architecture is that a higher layer can depend only on the layers directly above or below. This helps achieve SOLID design principles. 

## UI

The app uses a custom inherited widget for Colour management - decoupling the dependancy on Material Design. Whilst this limits the app's look and feel for Material You it does give the developers stricter control over the colour within the app, and also allows the app to apply multiple colour themes (such as light / dark and colour blindness modes for example.)

The app also uses other styles and widgets all named with the prefix 'app' to illustrate they are 'app wide' shared code. 

# Dependancy Injection

The app uses dependancy injection in for the form for Injectable. Injectable allows us to infer class dependancies via code generation and can be used in an advance way to switch dependancies based on run-time environments. 

The example usage shown here is basic but demonstrates its potential. 

## Localisation 

The app uses a localisations file allowing for the possible translation of this app in future. 

## State Management

The app uses the Cubit (Bloc) state management. There are two cubits within this project for demonstration purposes. Each cubit follows a common design pattern whereby the emitted states are named and used in a similiar way. 

The states a cubit can emit are named as follows:

- **CubitNameStateInitial** - a state to initialise the cubit with. Infers the cubit has not yet emitted. 
- **CubitNameStateLoading** - a state to suggest to the UI that the cubit is loading
- **CubitNameStateSuccess** - a state to tell the UI to load and render the results
- **CubitNameStateError** - a state to suggest a minor error (such as UI validation errors) 
- **CubitNameStateFailure** - a state to suggest an unrecoverable fault 

## Testing 

I have written 8 example tests to demonstrate how to test cubit units. 
In reality I would normally write more, extensive tests and also flesh out the mocked repositories with detailed expected test responses. 

There is also the option for Widget tests too - which this project has not implemented. 

## Areas of improvement 

- I would highly recommend against embedding API keys into the codebase. This has been done in this demo for the sake of time. 
- The UI was not a focus on this 'test' however if more time was available I would focus on designing a more interactive UI that is more visually pleasing.
- The API's (both Google Maps and Open Weather) are rate limited and may prevent requests after excessive usage.
- Reduce dependancy with the Open Weather UI components 
