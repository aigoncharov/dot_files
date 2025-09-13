# How to Caniculus

Short opinionated guide on how to (ab)use our beloved server Caniculus. If you face any errors or have any questions, feel free to pray that they go away on their own. Alternatively, reach out in the server chat in Telegram.

## Mount your data on SSD

By default, our home directories (`/home/username`) live on HDD. It is slooooow!
Create a folder for you at `/mnt/ssd/{username}` (for instance, mine is `/mnt/ssd/a.goncharov`). I clone all my code there and run trainings from it.

## Find who occupied GPU

### New cool way

Run `nvtop`

### Old way

Create `inspect-vram.sh` in your home directory.

```bash
#!/bin/bash
echo "Searching PID $1"

for i in $(docker container ls --format "{{.ID}}");
do
if docker top $i -o pid | grep -qc $1
then
echo " ID CONT $i"
docker inspect -f '{{.State.Pid}} {{.Name}}' $i
#docker top $i -o pid
fi
done
```

Usage example:

- Run `nvidia-smi`
- In the second table (at the bottom) find the PID of a script that runs on your desired GPU
- Run `~/inspect-vram.sh PID`. Example: `inspect-vram.sh 1214850`.
- Find the person in the Telegram chat.

## Use uv to manage dependencies

[uv](https://docs.astral.sh/uv/) is much^424242 times faster than pip. Zero reasons to keep using pip.
Feel free to take a look at https://github.com/LabARSS/complexity-aware-fine-tuning if you need an example of how to structure your project with uv. Though it is not guaranteed that it is indeed the best possible setup.

## Isolate your environment

Always run your scripts in docker! Always limit resource consumption: GPUs, CPUs, RAM!

How to manage your docker containers:

1. Create a docker image with `uv` preinstalled: [`~/uv.dockerfile`](uv.dockerfile)
2. Create `~/stacks` folder
3. For each project you are working on create a subfolder in `~/stacks`. Example: `~/stacks/aleotoric/`.
4. In the subfolder create [`compose.yml`](stacks/uv/compose.yml)
5. Run `docker compose up -d` from `~/stacks/project_name`. It starts your docker container in background.
6. Attach to it to play with the models: `docker compose attach container_name` (I usually type `docker compose attach`, press `tab` and let autocomplete handle the rest).

## Use tmux

[tmux](https://github.com/tmux/tmux/wiki) is a terminal multiplexer. It allows you to create terminal sessions that run in background which you can easily attach to and detach from. This way you can easily run multiple trainings in parallel.

Quick start:

1. `tmux` - creates a new session
2. `tmux attach` - attached to the last session
3. `tmux attach -t x` attaches to session x
4. Inside of tmux session:
   1. `cmd+b+d` - detach

## Setup easy SSH access

On your laptop add the following lines to `~/.ssh/config`:

```
Host caniculus
    HostName CANICULUS_IP_ADDRESS
    IdentityFile ~/.ssh/sktech
    IdentitiesOnly yes
    IgnoreUnknown UseKeychain
    UseKeychain yes
    User username
```

On Caniculus setup key-based SSH access (without password).

## Use VS code to edit code directly on caniculus

Once you add caniculus to SSH config, head to VS code and install https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh.
Now you can easily connect to any folder on caniculus from your vscode with a single command.

To be continued...
