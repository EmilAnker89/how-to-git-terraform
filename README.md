## Introduction to git by example

assuming a working installation of git and it already being configured:
the whole `$ git config --global user.email "email@example.com"` thing

### Typical workflow

Start by making a directory for the repository somewhere and change to that directory:

```
mkdir path/to/repo/name-of-repo && cd path/to/repo/name-of-repo
``` 

Initialize a new git repository with
```
git init
```

This will create a directory called *.git* in the current directory, which contains the state of your local git repository.
check out:
```
$ ls -al .git

total 44
drwxrwxr-x. 7 emil emil 4096 Jun 20 11:45 .
drwxrwxr-x. 3 emil emil 4096 Jun 20 11:45 ..
drwxrwxr-x. 2 emil emil 4096 Jun 20 09:24 branches
-rw-rw-r--. 1 emil emil  216 Jun 20 11:17 config
-rw-rw-r--. 1 emil emil   73 Jun 20 09:24 description
-rw-rw-r--. 1 emil emil   23 Jun 20 09:24 HEAD
drwxrwxr-x. 2 emil emil 4096 Jun 20 09:24 hooks
-rw-rw-r--. 1 emil emil  126 Jun 20 11:42 index
drwxrwxr-x. 2 emil emil 4096 Jun 20 09:24 info
drwxrwxr-x. 6 emil emil 4096 Jun 20 11:24 objects
drwxrwxr-x. 4 emil emil 4096 Jun 20 09:24 refs
```

This is not something you interact with directly. It contains the files *git* uses to keep track of the state of your repository - this is what can be compared and synced with a remote repository (we'll get to that)

Let's create a file, to see what's going on:
```
echo "contents of README file" > README.md
```
What does *git* think about this?

```
$ git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        README.md
```

What *git* is telling us here is that we have made a change in the repository to the file named README.md
(we know that we've created it and written something to the first line of this file)

So how do we tell *git* to help us keep track of this file?
```
git add README.md
```
which adds changes to the specific file README.md to next commit.

or
```
git add .
```
which would add all changes in the directory to the next commit.

what *commit*?

Well, a commit is the way git bundles up changes. Nothing is final before it is committed - you can change files back and forth all you want, add or remove them. The only thing git cares about is the changes to files it has been told to keep track of between last commit and the current "staged changes":

```
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   README.md
```
Since we told git to track changes to README.md (which also includes keeping track of whether it exists or not),
we are now being told that if we commit the current "staged changes", this commit will contain the creation of the file *README.md*

So what would happen if I now modify the file? Let's find out:

```
echo "blabla" >> README.md
```
```
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   README.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   README.md
```

So if we commit the current state, what would be committed?
Only those changes we have told git to keep track of would be committed.
So if we commit the current 'staged changes' and check out that commit at a later point, the contents of README.md at that particular point in time, we would get the version of README.md that only contains one line of text.
Let's do just that:
```
$git commit -m 'commit message'
```
Funny thing about git - comments are actually enforced.
You cannot commit anything without leaving a 'commit message' about what was changed in that particular commit.
Unfortunately you often see a lot of '.' commit messages, but best practice is to make them concise (one-liners) giving an idea of what was modified, without being a full documentation of the actual change - think of it as a search index.

Back to the point of how *git* handles 
To check out whether this is true or not, let's try out another handy git command:

```
$ git stash
Saved working directory and index state WIP on master: 55c4fe




