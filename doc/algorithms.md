# Algorithms 

Some algorithms which took some time to be figured out.

### **Time Check**

If the user tries to a add a new setting, we use this algorithm to check if the time overlaps with any of the existing settings.

Blow is the graphical explanation of the same.

<img src="https://raw.githubusercontent.com/Appiko/appiko-setup/development/doc/images/timeCheck.png" style="width:90%; height:400; margin:auto;" />


### **Ambient Light State**

We use a state machine to avoid overlapping Ambient times.

Following are the states values corresponding each ambient light.


AMBIENT LIGHT | STATE VALUE |   STATE VALUE (DECIMAL)
:--------------|-----------:|-----:
DAY ONLY (DO) |  `1 0 0` | 4
NIGHT ONLY (NO) |  `0 1 0`  | 2
DAY WITH TWILIGHT (DT) |  `1 0 1`| 5
NIGHT WITH TWILIGHT (NT) |  `0 1 1`  | 3   
TWILIGHT ONLY (TO) |  `0 0 1`  | 1




Every time a new setting is added we add the corresponding state value to the existing state value, which initially is zero.

So the possible combinations Sense devices can handle are: 

```
DO + NO + TO  = 7

NT + DO = 7

DT + NO = 7 

```

As we see the max state value that can be reached is 7.Hence, we do not allow any other setting when the state value reaches 7.

When the user wants to change the existing setting ambient time, we subtract the existing state and add the new state.

For example:

Existing setting has the state

` DT(5) +  NO(2) = 7` 

Suppose the user wants to change night only to something else,

` state value(5) = existing value (7) - value to be changed (2)`

So we can get the fields to be disabled for state 5, by computing a bitwise AND `&` operation between state and the ambient light value and if the result is greater than 0, the field would be disabled.

For example:
1. Current state (5) & Night Only (2)

```
  1 0 1
& 0 1 0
-------
  0 0 0 => Night only is enabled
-------
```

2. Current state (5) & Day only (4)

```
  1 0 1
& 1 0 0
-------
  1 0 0 => 4 > 0 => Day only is disabled
-------
```



