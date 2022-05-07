# Testing Report

## Automated Testing
###### Locations
Automated Test Suite: source_code/bicycle_trip_planner/test
Coverage Report: source_code/bicycle_trip_planner/coverage/html

###### Automated Test Suite
Our testing suite is broken into **Model**, **Manager** and **Widget** Tests

**Model Tests**: ensure that our data models build from JSON /or XML correctly and maintain valid types to midigate regression bugs from model changes.

**Manager Tests**: ensure that the operations on the programs main controlling datasets are operating as intended

**Widget Tests**: ensure the UI has the necessry components and is displaying the appropriate data

Through these test sets we can ensure that from API data in to displayed changes on screen the application is working as intended

![[CodeCoverage.png]]

Note: User Setting Tests only run on an Non MacOS device as a result of a macOS shared preferences issue and the test coverage report was generated on a mac therefore those tests will not be reflected in it

## Manual Testing
Manual testing allows for the application to be tested to ensure the real API data is working within the application and the overall application responds as it should.

### General
###### View Current Location Test
**Preconditions**: On Home/Route Planning/or Navigation

**Input**: Press View Current Location Button

**Expected Output**: Camera Views users current location

###### No Internet Connection Test
**Preconditions**: None

**Input**: Disconnect Internet Connection

**Expected Output**: Display no Internet Connection Screen

**Input**: Reconnect to Internet

**Expected Output**: No Internet Screen Disappears and application resumes

### Home Page
###### Search Test
**Preconditions**: On application open on the main landing page

**Input**: In the Search bar type Bush House and select 'Bush House, Aldwych, London ...'

**Expected Output**: Should be brought to the Route Planning Page with 'Bush House, Aldwych, London ...' set as destination and a marker displayed

###### Station Card Test
**Preconditions**: On application open on the main landing page

**Input**: Pressing on Station from station card

**Expected Output**: Pop up message to select between Start, Intermediate, End should appear

###### Station Marker Test
**Preconditions**: On application open on the main landing page

**Input**: Pressing on Station Marker on the map

**Expected Output**: Pop up message to select between Start, Intermediate, End should appear

###### Station Select Popup Test
**Preconditions**: On home page having pressed a station marker or station card

**Input**: Pressing Start, Intermediate or End

**Expected Output**: Should be brought to the Route Planning Page with 'Santander Cycles: ' then the station name you selected being displayed in the corresponding field and a marker displayed

###### Favourite Stations Test
**Preconditions**: On Home page, Logged in

**Input**: Favourite a Station, Switch to Favourite Stations

**Expected Output**: The Station favourited should be displayed

**Input**: Unfavourite the Station

**Expected Output**: The Station unfavourited should no longer be displayed (under favourite stations)

### Route Planning
###### Basic Route Test
**Preconditions**: On Route Planning Screen

**Input**: Search and Select Bush House as start destination and Buckingham Palace as end destination

**Expected Output**: A marker should be placed at Buckingham Palace, a station near Buckingham Palace, Bush House, and a station near Bush House. A polyline should be drawn passing through them and should follow the road system.

###### Route w/ Intermediate Test
**Preconditions**: Basic Route Test

**Input**: press add intermediate and on the newly displayed search bar, search and select Waterloo Station

**Expected Output**: Along with the already displayed markers from Basic Route Test there should be an addition marker at Waterloo Station and the polyline should update to connect that marker to the route.

###### Manual Intermediate Reorder Test
**Preconditions**: Route w/ Intermediate Test, Set Optimised to False, Add another Intermediate at Hyde Park

**Input**: Drag Hyde Park Intermediate above Waterloo Station on the intermediates list

**Expected Output**: The route will update and will route from Bush House to Hyde Park back to Waterloo then finally go to Buckingham Palace

###### Multiple Intermediate Optimised Route Test
**Preconditions**: Manual Intermediate Reorder Test

**Input**: Press Optimise Button and Set to True

**Expected Output**: The route will update and will route from Bush House to Waterloo Station to Hyde Park to Buckingham Palace. Even though Hyde Park appears first the on the list the optimise should go to Waterloo first for time efficiency.

###### View Route Test
**Preconditions**: Basic Route Test

**Input**: Press View Route Button

**Expected Output**: The map camera should centre and display the route

###### Clear Route Test
**Preconditions**: Basic Route Test

**Input**: Press the Clear button on either the start or end destination

**Expected Output**: The relevant marker should be removed and the polyline should be cleared

###### Walk to Distant Start Test
**Preconditions**: Basic Route Test, Current Location not at Bush House

**Input**: Press the walk/route to start button, on pop up select walk option

**Expected Output**: Route should display a walk polyline from current location to the nearest Bush House Bike Station available then the rest of the route as in Basic Route Test

###### Route to Distant Start Test
**Preconditions**: Basic Route Test, Current Location not at Bush House

**Input**: Press the walk/route to start button, on pop up select route option

**Expected Output**: Route should display a walk polyline to a station near current location and display a bike polyline to Bush House then the rest of the route as in Basic Route Test (without the Bush House Bike Station as user would have already picked up a bike)

### Navigation
###### Navigation Walking Start Test
**Preconditions**: Basic Route Test, with start set to current location

**Input**: Start Navigation Press

**Expected Output**: Redirected to Navigation screen, Walking polyline from current location to nearest station, Camera centred on user location, Directions displayed at top

###### Toggle to Biking Test
**Preconditions**: Navigation Walking Start Test

**Input**: set current location to station, press toggle to bike

**Expected Output**: Biking polyline end destination station that passes through intermediates, Directions updated, ETA update

###### Waypoint Arrival Test
**Preconditions**: Toggle to Biking Test

**Input**: Change location to first waypoint

**Expected Output**: Clear the waypoint from the route and show route to next waypoint, Directions update, ETA update

###### Toggle to Walk Test
**Preconditions**: Waypoint Arrival Test

**Input**: Press Toggle to walk

**Expected Output**: Walking waypoint to final destination, Directions update, ETA update

###### Arrive at Final Destination Test
**Preconditions**: Toggle to Walk Test

**Input**: Set current location to final destination

**Expected Output**: Pop up displaying you have arrived at destination, redirect to the home screen

### Log In / Setting 
###### Sign up Test
**Preconditions**: On Signup page

**Input**: Enter an email, password and confirmed password

**Expected Output**: Be brought to the user setting screen logged in as the user you signed up

###### Logout Test
**Preconditions**: Logged in as an user

**Input**: Press signout

**Expected Output**: Logged out, offer to login or sign up where account info used to be

###### Login Test
**Preconditions**: Have Signed up with credentials and logged out, currently on log in screen

**Input**: Input credentials entered when signing up, press log in when complete

**Expected Output**: redirected to the user setting screen with user info displayed

###### Login w/ Google Test
**Preconditions**: Have a valid google account and logged out, currently on log in screen

**Input**: Press login with google button and enter complete google's log in form

**Expected Output**: redirected to the user setting screen with user info displayed

###### Change Nearby Station Range Test
**Preconditions**: Current Location is central london, Set the Range to the min, observe the number of station markers displayed

**Input**: Change the Range to the max

**Expected Output**: The station markers should cover most of London on the map

###### Change Unit Test
**Preconditions**: None

**Input**: Change display unit in settings

**Expected Output**: On Home screen the station cards should reflect the unit change, On route planning and navigation the eta card should also change to reflect that unit

###### Favourite Stations Test
**Preconditions**: On Home page, Logged in

**Input**: Switch to Favourite Stations, tap on a Favourite station

**Expected Output**: A modal should ask whether the user wants to set that station as start, destination, or cancel the operation

**Input**: Switch to Favourite Stations, tap on a Favourite station, select start station from model

**Expected Output**: Redirection to RoutePlanning with start field box filled with favourite station

**Input**: Switch to Favourite Stations, tap on a Favourite station, select end station from model

**Expected Output**: Redirection to RoutePlanning with destination field box filled with favourite station

###### Favourite Routes Test
**Preconditions**: On Home page, Logged in

**Input**: Select 'Favourite Routes' from StationBar

**Expected Output**: The routes favourites should be displayed

**Input**: Remove the route from favourited

**Expected Output**: The Station unfavourited should no longer be displayed (under favourite stations)

**Input**: Select a favourite route

**Expected Output**: Redirection to RoutePlannig already filled with start, destination (and in case midway stops) from the favourite route

**Preconditions**: On RoutePlanning page, Logged in, starting point and destination filled
Input: Favourite the route

**Expected Output**: The route should have been added to favourite routes (visible from Home)

**Preconditions**: On Home page, Not Logged in

**Input**: none

**Expected Output**: No dropdown menus appear on StationBar, it is not possible to select Favourite Stations view
