from qiskit import QuantumCircuit
from qiskit_aer import AerSimulator
from qiskit.visualization import plot_histogram

def bell_state_experiment(shots=1024):
    qc = QuantumCircuit(2, 2)
    qc.h(0)
    qc.cx(0, 1)
    qc.measure([0, 1], [0, 1])

    counts = AerSimulator().run(qc, shots=shots).result().get_counts()
    print(f"Resultados Bell |Phi+> ({shots} shots):")
    for state, count in sorted(counts.items()):
        print(f"  |{state}> : {count:4d} ({count/shots*100:.1f}%)")
    assert "01" not in counts and "10" not in counts
    print("OK: correlación perfecta verificada")
    fig = plot_histogram(counts)
    fig.savefig("capturas/bell_histogram.png", dpi=150)
    return counts

if __name__ == "__main__":
    bell_state_experiment()
