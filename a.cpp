#include <cstdio>
#include <cstdlib>
#include <mpi.h>

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);
  std::system("./b.out");
  MPI_Finalize();
}
