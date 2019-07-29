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
It consists of a piece of software called Terraform and a declarative language called Hashicorp Configuration Language (HCL)
What Terraform does is provide a way in which to talk to different infrastructure providers using the same configuration language.
Several providers have implemented abstractions on top of their APIs in Terraform to have an easy interface for interacting with the 
provisioning services of that particular infrastructure provider.  
It is (typically) not necessary to strictly declare dependencies between components in Terraform, as this is implicitly done by reference.
Terraform can figure this out, because it generates and walks a Directed Acyclig Graph (DAG) during it's planning phase, 
meaning it will construct a graph of dependencies and based on this graph determine what has to be provisioned first, 
what can be provisioned in parallel and what is an invalid configuration (e.g. circular dependencies)
The last characteristic worth highlighting is the Terraform state. It can cause a lot of trouble but also seems like a necessary evil.
This state keeps track of what has been deployed by Terraform. It can be compared to either current state (has something in these resources been changed by something that isn't Terraform)
and during the planning phase - since we can compare what the latest Terraform deployment looks like, we don't need to figure out how to get from nothing to our new desired state -
if possible we can take a shortcut and reuse some of our existing components. If at all possible, we'd much rather modify existing components than redeploy them from scratch, 
but to do this properly, you need a tool like Terraform.
This is the best of two worlds - one in which you have everything described to achieve a certain state in one file/process (desired state configuration)
and you get to reuse existing components instead of having to redeploy.
For a more in-depth description of the Terraform architecture and components, see:
_link to description of terraform architecture, etc._


Let's walk through the components of a very basic Terraform project:

```
.
│   README.md
|    
└───project
    |   main.tf
    |   variables.tf
    |   terraform.tfvars
  
```

It can be a bit intimidating to see so many different files to describe a project, 
but it is really just a way to separate configuration of the different parts of a project.
a "project" is a collection of files in a certain location.
Terraform is very dependent on and strict about the repository structure, since it actually attempts to merge all files with 
suffix *.tf. in the directory in which you execute `terraform plan`.  
A very typical naming convention for files in a terraform project is:
main.tf, variables.tf, output.tf
main.tf contains the core functionality.
this will be declaration of resource and data objects (we'll dive into this in a bit), 
the references to the providers and backends (if state is hosted remotely) is also typically specified here.
variables.tf is like the schema definition of the Terraform project. This will typically just contain variable definitions.
This is the file in which you determine how many knobs user can use to alter the behavior of the "deployment".
You would also specify implicitly whether these variables are optional (because it has a default value) or mandatory.  
terraform.tfvars is a specific file (also files matching *.auto.tfvars) that acts as the interface to the project.
This is but ony way to supply variables to Terraform, but it is the most commonly used.
So where variables.tf contained the declaration of specific variables, terraform.tfvars would contain the actual values of those variables.
This is the least static part of the Terraform project - if you have to alter something in main.tf often, it is probably worth specifying
a variable to handle this and set it's value in terraform.tfvars, making the interface as slim as possible.
Later on we'll cover different other ways of passing variables to Terraform and how Terraform handles inputs from different sources.

But let us first take a look at a simple main.tf file (project1/main.tf):

let's take a look at the main.tf file:
[main.tf](project1/main.tf)  
This tiny bit of code does nothing more than state the provider (which in this case is the Azure Resource Manager - _azurerm_)
and defines a resource group to be created.
For documentation about the interface of azurerm_resource_group:
https://www.terraform.io/docs/providers/azurerm/r/resource_group.html  
This resource type is an abstraction in the form of a wrapper around (some of) the `az group *` commands in the azure cli.


[variables.tf](project1/variables.tf)  
the var.* references in main.tf are defined in this file. As mentioned before, there really isn't any reason (from a functionality point of view)
to separate main.tf and variables.tf into two files, but it is a nice way to separate different types of definitions.

[terraform.tfvars](project1/terraform.tfvars)  
contains a simple assignment. The syntax is the subset of HCL that relates to data structures.
You can only define data structures that are valid in HCL.
for information on variable types see: https://www.terraform.io/docs/configuration/variables.html

***
### first Terraform deployment
The contents of _project1_ would let you deploy a resource group on Azure.

Please beware that Terraform will use the current Azure session information for the deployment (unless otherwise specified),
so make sure that your current session is attached to a subscription in which you are allowed to and can deploy resources.
This information is inherited from the parent process of Terraform.

`az login -u <username> -p <password>`  
And typically you'd specify the subscription context in the parent process rather than in Terraform:
`az account set --subscription <subsription>`

Initialization of a Terraform project is a separate step, which is responsible for defining Terraform's dependencies.
This would mainly consist of plugins, backend configuration and modules.
E.g. if you navigate to the _project1_ directory and execute `terraform init` nothing is actually deployed, but Terraform will fetch all dependencies
to be able to deploy whatever is referenced in your configuration.
In our case it will:
 - initialize a backend (the statefile)
 - download provider plugin for azurerm  
 
Terraform aims to be as slim as possible, this is one of the reasons why the provider plugins do not ship with Terraform itself - you only fetch what you need, when you need it.
This is true for modules as well (which we'll cover later on), making it possible to reference other HCL definitions (and specific versions of those).
What this also means though, is that you have to rerun `terraform init` whenever you change a provider or backend block or the source in a module block has changed. 

After initializing the Terraform project, you will notice a .terraform folder, which in our case contains the latest version of the azurerm plugin as an executable file in:
_.terraform/plugins/<os-name>/terraform-provider-azurerm_v<XXX>_  
Note that the statefile has not yet been created, since we haven't actually deployed anything. 
implicitly however, (since there is no terraform.tfstate reference under .terraform) we now know that the statefile will be kept locally.

The provisioning based on a Terraform configuration consists of the two steps; _plan_ and _apply_
The _plan_ phase generates the graph based on the configuration in the *.tf files. It then traverses this graph to determine what has to be deployed in which order and what can be deployed in parallel.
The _apply_ phase is then the actual execution of the plan.
The _plan_ phase can be thought of as a way of determining whether the HCL declarations themselves are valid ("think compilation").
Since Terraform doesn't know everything about the backends it talks to, you will get many error messages/warnings passed on from the backend services:
e.g. field restrictions of various azure resources being an inconsistent pain in the a\*\*.  
The main point is, the HCL code can make complete sense to Terraform, but because the backend services have various other restrictions that aren't surfaced through Terraform,
you will not run into them before you try to actually use these services for deploying resources.
So expect to get errors during _apply_ phases even when your _plan_ passed successfully.

try running `terraform apply`. By default this actually runs both the plan and the apply phase in one (handy for interactive use).
but it can also take a generated plan as an input.
Without specifying any options for `terraform apply`, it will _wait_ at the stage where the plan is created and prompt the user to determine whether the actual _apply_ phase should be executed.

As mentioned previously, there are different ways of supplying input to Terraform.
One additional way is supplying them as -var or -var-file flags to the terraform commands.
try something like: 
```bash
terraform plan -var "rg_name=my_test_res_group"
```

Because of the nature of resource groups in Azure, Terraform will tell you what needs to be changed to get from the current configuration to the desired configuration.
In the case of a rename of a resource group in Azure, 1 resource needs to be _destroyed_ and 1 needs to be _added_.  
This is because of Azure internals that do not allow for renaming of resource groups.

But we don't have to remember to delete and then create the new resource group as we would if we were interacting with the *azure cli*.
Terraform knows now that the resource group it used to manage the lifecycle of is now obsolete; thus it will destroy it for us.
Also if someone accidentally deleted a resource Terraform was managing, it would compare its configuration to the current state and 
let us know that there is a difference between the two. The next `terraform apply` we run, would then ask to be allowed to redeploy whatever is missing.



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

