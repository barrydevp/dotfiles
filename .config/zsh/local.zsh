# For compilers to find libffi you may need to set:
export LDFLAGS="-L/usr/local/opt/libffi/lib"
export CPPFLAGS="-I/usr/local/opt/libffi/include"

# For pkg-config to find libffi you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"

# If you need to have sqlite first in your PATH run:
export SQLITE="/usr/local/opt/sqlite"
export PATH="$PATH:$SQLITE/bin"

# For compilers to find sqlite you may need to set:
export LDFLAGS="-L/usr/local/opt/sqlite/lib"
export CPPFLAGS="-I/usr/local/opt/sqlite/include"

# For pkg-config to find sqlite you may need to set:
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

#To use the bundled libc++ please add the following LDFLAGS:
# export LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"

#llvm is keg-only, which means it was not symlinked into /usr/local,
#because macOS already provides this software and installing another version in
#parallel can cause all kinds of trouble.

#If you need to have llvm first in your PATH, run:
# export PATH="/usr/local/opt/llvm/bin:$PATH"

#For compilers to find llvm you may need to set:
# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"

# ---- KUBE -----
KUBECONFIG=$HOME/.kube/config

OB_GETTING_STARTED_PATH=$HOME/Desktop/Dev/Foobla/Project/platform126/getting-started

MY_KCONFIG=$HOME/.kube/gke_platform126_us-central1-c_staging.yaml
for configFile in $(ls $OB_GETTING_STARTED_PATH | grep .yml)
do 
    if [ -z $MY_KCONFIG ]
    then
        MY_KCONFIG=$OB_GETTING_STARTED_PATH/$configFile
    else
        MY_KCONFIG=$MY_KCONFIG:$OB_GETTING_STARTED_PATH/$configFile
    fi
done
export MY_KCONFIG

### JAVA ###
export JAR=$HOME/.local/lang-server/jdt-language-server/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar
export GRADLE_HOME=$HOME/Desktop/Dev/Java/gradle
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-11.0.10.jdk/Contents/Home
export JDTLS_CONFIG=$HOME/.local/lang-server/jdt-language-server/config_mac
export JDTLS_HOME=$HOME/.local/lang-server/jdt-language-server
export WORKSPACE=$HOME/Desktop/Dev/Java/workspace
####

fwd() {
    if [[ $1 == "kill" ]]; then
        sudo kill $(paste -s -d " " <(ps -a | grep kubectl | awk 'NF == 9 {print $1}'))

        return 0
    fi;
    sudo cp -p ~/hosts.fwd /etc/hosts

    for arg in "$@"
    do
        case $arg in
            kill)
                fwd mongo &
                fwd nats &
                fwd redis &
                fwd redis-lock-0 &
                fwd redis-lock-1 &
                fwd redis-lock-2 &
            ;;

            all)
                fwd mongo &
                fwd nats &
                fwd redis &
                fwd redis-lock-0 &
                fwd redis-lock-1 &
                fwd redis-lock-2 &
            ;;

            mongo)
                sudo ifconfig lo0 alias 127.1.27.17 up

                k port-forward --address 127.1.27.17 svc/dev-mongodb 27017:27017
            ;;
            
            redis)
                sudo ifconfig lo0 alias 127.1.27.43 up

                k port-forward --address 127.1.27.43 svc/dev-redis-master 6379:6379
            ;;

            redis-lock-0)
                sudo ifconfig lo0 alias 127.1.27.44 up

                k port-forward --address 127.1.27.44 svc/redis-locks-0-master 6379:6379
            ;;

            redis-lock-1)
                sudo ifconfig lo0 alias 127.1.27.37 up

                k port-forward --address 127.1.27.37 svc/redis-locks-1-master 6379:6379
            ;;

            redis-lock-2)
                sudo ifconfig lo0 alias 127.1.27.21 up

                k port-forward --address 127.1.27.21 svc/redis-locks-2-master 6379:6379
            ;;

            nats)
                sudo ifconfig lo0 alias 127.1.27.16 up

                k port-forward --address 127.1.27.16 svc/dev-nats-nats-client 4222:4222
            ;;
            
            *)

            ;;
        esac
    done
}

ku() {
    echo "Starting update kube config"

    cd ~/Desktop/Dev/Foobla/Project/platform126/getting-started && \
    git pull origin && \
    # cp ./dev-kubeconfig.yml ~/.kube/config
    # cat ~/.kube/config

    echo "Done update kube config"
}

foobla() {
    case $1 in
        fwd)
            shift

            if [[ -z $1 ]]; then
                sudo kubefwd svc -n default $@
            else
                configFile=/Users/apple/Desktop/Dev/Foobla/Project/platform126/getting-started/$1-kubeconfig.yml
                shift
                sudo kubefwd svc --kubeconfig=$configFile -n default $@
            fi
        ;;

        kube)
            shift

            sudo nvim ~/.kube/config
        ;;

        ku)
            shift

            echo "current: $current_pwd"

            echo "STARTING --->"

            cd ~/Desktop/Dev/Foobla/Project/platform126/getting-started && \
            git stash && \
            ggl && \

            echo "PULL NEW OK --->"

            KUBECONFIG=$MY_KCONFIG kubectl config view --merge --flatten > ~/.kube/config

            echo "COPY OK --->"

            [ ! -z $1 ] && cat ~/.kube/config

            cd $current_pwd
        ;;
        
        P|p)
            shift
            cd ~/Desktop/Dev/Foobla/Project/platform126/$@
        ;;

        U|u)
            shift
            cd ~/Desktop/Dev/Foobla/Utils/$@
        ;;

        s1|ssh1)
            shift
            ssh root@157.245.192.117
        ;;

        s2|ssh2)
            shift
            ssh root@159.89.193.144
        ;;

        coolie)
            shift
            case $1 in
                dev|d)
                    cp ~/dev.coolie.json ~/.coolie.json
                ;;
                
                prod|production|p)
                    cp ~/production.coolie.json ~/.coolie.json
                ;;

                mdev|md)
                    cp ~/.coolie.json ~/dev.coolie.json
                ;;
                
                mprod|mp)
                    cp ~/.coolie.json ~/production.coolie.json
                ;;

            esac
        ;;

        npm_token)
            shift
            echo f0900c94-b98b-4d7e-b64d-3540866f4fe5
        ;;

        *)
            cd ~/Desktop/Dev/Foobla/$@
        ;;

    esac
}

oapp() {
    # $1 &
    $1 </dev/null &>/dev/null &
}

barry() {
    case $1 in
        # start)
        #     shift

        #     oapp "ibus-daemon"
        #     oapp "touchpad-indicator"
        # ;;

        d|dev)
            shift
            cd ~/Desktop/Dev/$@
        ;;

        git)
            shift
            cd ~/Desktop/Dev/github.com/barrydevp/$@
        ;;

        ssh)
            shift
            ssh root@34.126.65.44
        ;;

        *)
            cd ~
        ;;
    esac
}
