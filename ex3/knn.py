import csv
import math
def calculate_distance(p1, p2, r):
    sum_pow = sum(abs(a - b) ** r for a, b in zip(p1, p2))
    return sum_pow ** (1/r)

def get_min_max_ranges(dataset):
    num_features = len(dataset[0]) - 1
    mins = [min(row[i] for row in dataset) for i in range(num_features)]
    maxs = [max(row[i] for row in dataset) for i in range(num_features)]
    ranges = [maxs[i] - mins[i] for i in range(num_features)]
    return mins, maxs, ranges

def normalize(features, mins, maxs):
    return [(features[i] - mins[i]) / (maxs[i] - mins[i]) if maxs[i] != mins[i] else 0
            for i in range(len(features))]

def main():
    filename = "bank.data"
    dataset = []
    try:
        with open(filename, 'r') as file:
            reader = csv.reader(file)
            for row in reader:
                if not row: continue
                dataset.append([float(x) for x in row[:-1]] + [row[-1]])
    except FileNotFoundError:
        print(f"Error: {filename} not found.")
        return

    num_instances = len(dataset)
    num_features = len(dataset[0]) - 1
    print(f"Loaded {num_instances} instances.")
    r = float(input("Enter value for r (1 or 2): "))
    query_raw = input(f"Enter {num_features} query values: ")
    query_instance = [float(x) for x in query_raw.split()]
    mins, maxs, ranges = get_min_max_ranges(dataset)
    valid_ranges = [rg for rg in ranges if rg > 0]

    needs_norm = (max(valid_ranges) / min(valid_ranges) > 10) if valid_ranges else False
    if needs_norm:
        print("Normalization applied.")
        final_query = normalize(query_instance, mins, maxs)
    else:
        final_query = query_instance
    results = []
    for row in dataset:
        features = row[:-1]
        label = row[-1]
        calc_feats = normalize(features, mins, maxs) if needs_norm else features
        dist = calculate_distance(calc_feats, final_query, r)
        results.append({'orig': features, 'dist': dist, 'label': label})
    sorted_res = sorted(results, key=lambda x: x['dist'])
    for rank, item in enumerate(sorted_res, 1):
        item['rank'] = rank

    print("---- DATASET DESCRIPTION ----\n")
    print("Feature 1: Variance\n");
    print("Feature 2: Skewness\n");
    print("Feature 3: Curtosis\n");
    print("Feature 4: Entropy\n");
    print("\n--- DATASET DISTANCES ---")
    feat_hdrs = " ".join([f"F{i+1:<7}" for i in range(num_features)])
    header = f"{feat_hdrs}   {'Distance':<10}   {'Rank'}"
    print(header)
    print("-" * len(header))
    for res in results:
        f_str = " ".join([f"{x:<8.2f}" for x in res['orig']])
        print(f"{f_str}   {res['dist']:<10.2f}  {res['rank']}")
    print()
    k = int(input("Enter value for K: "))
    print("Choose Voting Method:")
    print("1. Unweighted")
    print("2. Weighted")
    choice = input("Enter choice: ")
    k_neighbors = sorted_res[:k]
    scores = {}
    print(f"\n--- TOP {k} NEIGHBORS ---")
    if choice == '2':
        header_k = header + "   Label        Weight"
    else:
        header_k = header + "   Label"
    print(header_k)
    print("-" * len(header_k))
    for n in k_neighbors:
        f_str = " ".join([f"{x:<8.2f}" for x in n['orig']])
        if choice == '2':
            weight = 1 / (n['dist'] + 1e-9)
            scores[n['label']] = scores.get(n['label'], 0) + weight
            print(f"{f_str}   {n['dist']:<10.2f}   {n['rank']:<4}   {n['label']:<10}   {weight:.2f}")
        else:
            scores[n['label']] = scores.get(n['label'], 0) + 1
            print(f"{f_str}   {n['dist']:<10.2f}   {n['rank']:<4}   {n['label']}")

    print("\n--- VOTING ---")
    for label, score in scores.items():
        print(f"Label '{label}': {score:.1f}")
    winner = max(scores, key=scores.get)
    print(f"\nFINAL PREDICTION: {winner}")
    if len(scores) > 1:
        labels_list = list(scores.keys())
        l1, l2 = labels_list[0], labels_list[1]
        if scores[l1] > scores[l2]:
            print(f"(Result: {l1} > {l2})")
        elif scores[l2] > scores[l1]:
            print(f"(Result: {l2} > {l1})")
        else:
            print("(Result: {l2} = {l1})")
if __name__ == "__main__":
    main()
