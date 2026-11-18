from qiskit import QuantumCircuit
from qiskit_aer import AerSimulator

def oracle_constante(n):
    return QuantumCircuit(n + 1)

def oracle_balanceada(n):
    qc = QuantumCircuit(n + 1)
    for i in range(n):
        qc.cx(i, n)
    return qc

def deutsch_jozsa(oracle_qc, n, shots=1024):
    qc = QuantumCircuit(n + 1, n)
    qc.x(n)
    qc.h(range(n + 1))
    qc.compose(oracle_qc, inplace=True)
    qc.h(range(n))
    qc.measure(range(n), range(n))
    return AerSimulator().run(qc, shots=shots).result().get_counts()

if __name__ == "__main__":
    n = 2
    counts_c = deutsch_jozsa(oracle_constante(n), n)
    counts_b = deutsch_jozsa(oracle_balanceada(n), n)
    print(f"Constante: {counts_c}")
    print(f"Balanceada: {counts_b}")
    assert "00" in counts_c
    assert "00" not in counts_b
    print("OK: Deutsch-Jozsa verifica correctamente")
