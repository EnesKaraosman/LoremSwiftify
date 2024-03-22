Steps to lorem struct / class

Pre conditions to start
- Make sure macro is applied to struct / class
- Make sure struct / class has member

-----
abbrevition SC = struct / class

if class
Note: class must have init if there is uninitialized member exist

- Capture init & it's members and lorem (use default value if exist)

if struct
- Check if there's defined init
    - Yes: 
    Iterate parameters, use default value if given. otherwise lorem based on type
    - No:
    Iterate stored members, use default value if given. otherwise lorem based on type
