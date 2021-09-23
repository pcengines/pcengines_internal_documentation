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

- Create a .md file inside the created folder 

- Write the content in the file.

    ```
        # some description

        ## Usage
        This is ...

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
