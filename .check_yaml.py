import yaml
import sys

for p in sys.argv[1:]:
    try:
        docs = list(yaml.safe_load_all(open(p)))
        print(f"OK {p}: {len(docs)} docs")
        for i, d in enumerate(docs):
            if d is None:
                print(f"  [{i}] None")
                continue
            k = d.get("kind")
            n = d.get("metadata", {}).get("name") if isinstance(d.get("metadata"), dict) else None
            api = d.get("apiVersion")
            print(f"  [{i}] {api} / {k} / {n}")
    except yaml.YAMLError as e:
        print(f"YAML ERROR in {p}: {e}")
