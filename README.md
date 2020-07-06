# hurricane_tools
documents of all modules -> `./documents`


axisym_vortex.py
------
[document](./documents/axisym_vortex.md) 

| Function | Description |
| :------- | :---------- |
| <font color="#a77864"> **rankine_vortex** </font> | Classic rankine vortex. |
| <font color="#a77864"> **holland80** </font> | The empirical formula of TC axisymmetric structure by Holland (1980). |
| <font color="#a77864"> **willoughby04** </font> | The empirical formula of TC axisymmetric structure by Willoughby (2006). |


******
center.py
------
[document](./documents/center.md) 

| Function | Description |
| :------- | :---------- |
| <font color="#a77864"> **ty_center_mslp** </font> | Find typhoon center by minimum sea level pressure grid (no weighted). |
| <font color="#a77864"> **weighted_ty_center** </font> | Giving first guess typhoon center longtitude and latitude, calculate the new center by weighted mothod. |


******
circular.py
------
[document](./documents/circular.md) 

| Function | Description |
| :------- | :---------- |
| <font color="#a77864"> **circular_avg** </font> | Calculate circular mean. |
| <font color="#a77864"> **circular_avg_closure** </font> | Calculate circular mean. |
| <font color="#a77864"> **rmw** </font> | Find TC RMW |
| <font color="#a77864"> **axissymmetricity** </font> | Calculate axissymmetricity based on Miyamoto and Takemi (2013). |


******
distance.py
------
[document](./documents/distance.md) 

| Function | Description |
| :------- | :---------- |
| <font color="#a77864"> **latlon2distance** </font> | calculate the distance (km) of two positions |
| <font color="#a77864"> **find_lonlat_with_distance** </font> | Find the longtitude/latitude which the horizontal or vertical distance to the (clon, clat) is equal to 'distance'. |


******
parse_wrf_center_mesg.py
------
[document](./documents/arse_wrf_center_mesg.md) 

| Function | Description |
| :------- | :---------- |
| <font color="#a77864"> **parse_wrf_rsl_error** </font> | Parse `rsl.error.0000` outputed from WRF to get the center information. If parse file successfully, it would create `center.txt` in the current folder. |
| <font color="#a77864"> **find_centers_nearest_time** </font> | Find the hurricane center data at specific times from the file which contains center information based on WRF rsl.error.0000. |


******
transform.py
------
[document](./documents/transform.md) 

| Function | Description |
| :------- | :---------- |
| <font color="#a77864"> **uv2vrvt_rt** </font> | Calculate Vr (radial wind) and Vt (tangential wind) on r-theta coordinate (polar coordinate). |
| <font color="#a77864"> **uv2vrvt_xy** </font> | Calculate Vr (radial wind) and Vt (tangential wind) on cartesian coordinate. |


******