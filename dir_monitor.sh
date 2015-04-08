#!/bin/sh
#Gustavo Lazarotto Schroeder

function snapshot_dir() {
  lsof $1 | awk '{print $1" "$2" "$9}'  
}

function ver5tentativas(){ #verifica a ocorrencia de apenas 5 execuções
   if [ $1 -eq 5 ]; then
	exit 5
    fi 
}

function testesSintax(){     #verifica sintaxes
if test -z "$MON_DIR"; then
   echo "voce esqueceu de definir MON_DIR"
   exit 1
fi

if [ ! -d "$MON_DIR" ]; then
   echo "Diretorio '$MON_DIR' não existe" > /dev/stderr
   exit 2
fi

if [ $# -eq 0 ] || [ ! -f "$1" ] || [ ! -x "$1" ]; then
   echo "Comando não informado, ou não é programa executável"
   exit 3
fi
}

function monitoramento(){
contador=0
antiga_foto_dir=$(snapshot_dir "$MON_DIR")
while true;
do 
  sleep 1  
  nova_foto_dir=$(snapshot_dir "$MON_DIR")  
  if [ "$antiga_foto_dir" != "$nova_foto_dir" ]; then        # conteudo/lista de acessos mudou
     nohup ["$1"] & contador=$($contador+1) 
     antiga_foto_dir=$nova_foto_dir
fi
  ver5tentativas $contador
done
  if true  #organiza e executa
  then
     	testesSintax $#
	FOTO_MUDOU_CMD="$*"
	monitoramento $FOTO_MUDOU_CMD
  fi
done
}
















