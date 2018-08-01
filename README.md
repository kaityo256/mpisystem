MPIプログラムからMPIプログラムをstd::systemで呼び出すサンプル
===

[![License: CC0-1.0](https://img.shields.io/badge/License-CC0%201.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0/)

# 何が問題か

MPI_Init/Finalizeを呼び出すコードから、さらにMPI_Init/Finalizeを呼び出すコードをstd::system関数で子プロセスとして呼び出すと一般に正しく実行できない。おそらくMPI_Finalizeが問題を起こしている。

# サンプルコード

呼び出し側(a.cpp)

```cpp
#include <cstdio>
#include <cstdlib>
#include <mpi.h>

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);
  std::system("./b.out");
  MPI_Finalize();
}
```

呼び出され側(b.cpp)

```cpp
#include <cstdio>
#include <mpi.h>

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);
  printf("Hello World\n");
  MPI_Finalize();
}
```

コンパイルと実行 (Open MPIの場合)

```
$ mpicxx a.cpp -o a.out 
$ mpicxx b.cpp -o b.out
$ mpiexec -np 2 ./a.out
Hello World
Hello World # ← ここでプログラム実行が止まり、正常終了しない
```

上記の状態でCtrl+Cを押すとSIGSEGVで落ちる。

Intel MPIの場合は以下のようなエラーが出る。

```
===================================================================================
=   BAD TERMINATION OF ONE OF YOUR APPLICATION PROCESSES
=   PID XXXX RUNNING AT hostname
=   EXIT CODE: 13
=   CLEANING UP REMAINING PROCESSES
=   YOU CAN IGNORE THE BELOW CLEANUP MESSAGES
===================================================================================
```

