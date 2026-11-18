from qiskit import QuantumCircuit
from qiskit_aer import AerSimulator
from qiskit.visualization import plot_histogram

def grover_2qubits(target="11", shots=1024):
    qc = QuantumCircuit(2, 2)
    qc.h([0, 1])
    for qubit, bit in zip([1, 0], target):
        if bit == "0":
            qc.x(qubit)
    qc.cz(0, 1)
    for qubit, bit in zip([1, 0], target):
        if bit == "0":
            qc.x(qubit)
    qc.h([0, 1])
    qc.x([0, 1])
    qc.cz(0, 1)
    qc.x([0, 1])
    qc.h([0, 1])
    qc.measure([0, 1], [0, 1])

    counts = AerSimulator().run(qc, shots=shots).result().get_counts()
    print(f"Grover buscando |{target}> ({shots} shots):")
    for state, count in sorted(counts.items()):
        print(f"  |{state}>: {count:4d} ({count/shots*100:.1f}%)")
    top = max(counts, key=counts.get)
    print(f"Estado más probable: |{top}> — {'CORRECTO' if top == target else 'ERROR'}")
    fig = plot_histogram(counts)
    fig.savefig(f"capturas/grover_{target}.png", dpi=150)
    return counts

if __name__ == "__main__":
    for target in ["00", "01", "10", "11"]:
        grover_2qubits(target)
