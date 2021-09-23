# This repository contains pcengines.github.io/pcengines_internal_documentation page files.

#### To create a new post

- Create a directory inside the root folder.

- Create a index.md file inside the created folder.

    ```
          ---
          layout: dir_list
          title: Board Modifications
          description: Board modifications 
          ---
    ```

- Creat a .md file inside the created folder 

```
   some_file.md
```

- Write the content in the file.

    ```
        # lpc1a

        ![image](https://user-images.githubusercontent.com/18163327/134538528-fc98b688-2dca-4306-ac66-021d2c83276a.png)

        ## Usage
        The lpc1a is needed as an alternative BIOS if on-board BIOS is not functional.

        ## Flash ROM size
        The apu1 boards have a 16Mbit (2MB) flash chip and the BIOS files need to be the same size.
        For use with smaller 8Mbit (1MB) flash chips use this minimized BIOS version: 

        [apu1_v4.8.0.6_8mbit.zip](https://github.com/pcengines/pcengines_internal_documentation/files/7219025/apu1_v4.8.0.6_8mbit.zip)

    ```
    
    
#### Create new pages, such a breeze!

- Create a .md file in the root directory.
- 
- Name the file with the desired page link name.

```
   about.md
```

```
   design.md
```

- Write the Front Matter and content in the file.

```
          ---
          layout: page
          title: String Title of the webpage
          permalink: / String / Permalink for the webpage
          tagline: String Optional DevJournal Feature : Tagline for the page
          ---
```      
```
        ---
        layout: page
        title:  "Science"
        permalink:   /science/
        tagline : "Humanity is overrated."
        ---
```
