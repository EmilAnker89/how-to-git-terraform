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

So what would happen if we now modify the file? Let's find out:

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

This would mean only the current 'staged changes' would be added, and were we to check out this commit at a later point, the contents of README.md at that particular point in time, would be the version of README.md that only contains one line of text.
Let's do just that:
```
$git commit -m 'added README file'
```
Funny thing about git - comments are actually enforced.
You cannot commit anything without leaving a 'commit message' about what was changed in that particular commit.
Unfortunately you often see a lot of '.' commit messages, but best practice is to make them concise (one-liners) giving an idea of what was modified, without being a full documentation of the actual change - think of it as a search index.

To check out whether what I claimed above is true, let's try out another handy git command:

```
$ git stash
Saved working directory and index state WIP on master: 55c4fe commit message
HEAD is now at 55c4fe commit message

$ git status
On branch master
nothing to commit, working tree clean
```

Now what is this suppose to mean?
What *git* just did, was to *stash* away our unclean state (whatever happens between commits).
What are we looking at now then?
We are looking at the state of the repository as of last commit. We can now jump to any other commit (e.g. another branch) and have a look around, start committing stuff there, before jumping back to our *stashed* away state.

```
$ cat README.md
contents of README file

$ git stash list
stash@{0}: WIP on master: 55c4fe commit message

$ git stash apply 0
(...)

$ cat README.md
contents of README file
blabla
```

It is very typical in software development to work on several different 'branches' of the same code-base.
branches are use for a variety of workflows, but a very common pattern is branching out each time you implement a new feature (which doesn't concern others than those working on coding that particular feature - until it is finished).
You will find yourself jumping back and forth between branches - when doing this the actual contents of the directory you are working in will be modified by git. For that reason it is very useful to be able to stash away a 'messy' state without committing it.
But keep in mind that this is for your local repository only - only commits are synced against remote repositories.

Let's say we are happy with the current changes and add the changes to README.md to a second commit.
Notice the little shortcut:
```
$ git commit -am 'second commit'

```

Work as a team:
Typically you'd just go to the github.com website and create an empty repo:
Just because it is easy, let's call it the same thing as the directory we just created.
the path would be something like https://github.com/username/reponame.git

```
$ git remote add origin https://github.com/<username>/<reponame>.git
$ git push -u origin master
```
Now we have pushed the state of our local git repo to a remote repository, that others can now work with.
What they would do to download this state would be to run:
```
$ git clone https://github.com/<username>/<reponame> path/to/download/to/reponame
```

This operation is only done once, since you do not want to clone/pull the entire history of the repository every time you have to sync with the remote state.
As per construction, the history of a git repository rarely changes - and typically not a big chunk of the history.
Hence, you would typically just like to pull the changes to the remote repository since the last time you synced.
To illustrate how this is different from cloning, let's take a look at the following chunk of code:


```
$ cd path/to/repo/name-of-repo
$ echo "tmp" > tmp.txt
$ git commit -am "added tmpfile"
$ git push

$ cd path/to/download/name-of-repo
$ git fetch
$ git status
$ git pull

```
Assuming we've downloaded the state of our remote repository to *path/to/download/name-of-repo*,
we currently have the repository in two different locations.
Using the original repository in *path/to/repo/name-of-repo* we've added a new file called tmp.txt and pushed that change to our remote repository.

Changing to the recently cloned repository at *path/to/download/name-of-repo*, running a git fetch will show us how our state differs from the remote.
(we should be 1 commit behind remote)
`git fetch` doesn't actually merge the remote state with the current local one.
It is frequently used to check if there are and what changes have been made to the remote repository since the last sync.
`git pull` on the other hand actually merges the states - so make sure that your local state is clean when doing `git pull`.

### Branching
It isn't very convenient to have the remote state changing all the time. We might even be working on something that will introduce broken changes or unfinished features, that we do not want others to experience before we are done implementing them.
How does git accommodate this?
git has the concept of branches. We haven't touched on it until now, but you have seen the reference to *master* quite a few times already.
This is the default branch of a git repository (created when you ran -git init-). The latest state of *master* is typically expected to contain a working version of the code.
What is deployed to a *real* environment is typically based on processes tracking the *master* branch.
But just to be clear, the *master* branch doesn't have any special status in itself - it is merely the branch created by default.

To efficiently work as a team, it would quickly prove troublesome or at least tedious to only work against this one branch.
This is where the concept of branching helps out. We can introduce new features and even temporary breaking changes, 
without messing up the *master* branch. 
A new branch is always initiated from a tracked state of the repository (typically the current state of the master branch).

```
$ git branch feature/new_feature
$ git checkout feature/new_feature
(or git checkout -b feature/new_feature as a one-liner)
```

A new branch is created with the `git branch [old-branch] new-branch` command.
If no *old-branch* is supplied, it branches out from the current branch (checked out commit to be exact), which means the above is equivalent to `git branch master feature/new_feature`
`git checkout` is the command used to navigate in the history of the git repository.
If you specify a branch, it will change the repository to look like the most recent commit of the current branch (which in this case is the branch we just created)
It is also what you'd use to checkout a specific point in the git history (a specific commit hash value or tag)

When we are done developing our new feature, the process of applying those changes to our master branch as well, is done in the form of a *merge*.
This attempts to merge the changes from one git branch into another - this is in itself a commit (called a merge commit), that is used to handle possible conflicts between the two states.
There are other ways of merging branches, but this should be your go-to, because it explicitly asks you to determine how to branches should be merged together.

When a branch is ready to be merged, it is typically merged with the branch it was initiated from.

```
$ echo "123" > tmp.txt
$ git commit -am "feature/new_feature content"

$ git push -u origin feature/new_feature
$ git pull

$ git merge feature/new_feature master

```
The code chunk above commits a simple change to tmp.txt and pushes this to the remote storage.
This is also what makes the branch visible to others tracking the remote repository.
What might not be obvious is why you'd do a `git pull` before merging the feature-branch changes into master.


A common practice when working with branches, is rebasing before a merge.
Without getting practical, the idea is when working with a separate branch, you tend to have slightly messy commits
You commit to track your changes and maneuver around in the branch's commits while developing that particular feature,
but when you are ready to introduce it to the master branch, you might want to tidy up those commits - bundle up file changes differently,
maybe even just bundle the entire feature addition into one commit (very often done for pull requests as we'll get to in a bit).

As a rule of thumb though, never change the history of the master branch, unless strictly necessary.

***
### Terraform
Terraform consists of a piece of software and a language for provisioning infrastructure.
_link to description of terraform architecture, etc._

Let's walk through the components of a typical Terraform project:

```
.
│   README.md
|    
└───project
|   |   main.tf
|   |   variables.tf
|   |   output.tf
|   |   terraform.tfvars
|
|___modules
    |   main.tf
    |   variables.tf
    |   output.tf 
  
```


