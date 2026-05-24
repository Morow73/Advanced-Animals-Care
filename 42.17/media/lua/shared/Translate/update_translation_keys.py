import json
from pathlib import Path

root = Path(__file__).resolve().parent
translations = {
    'AR': {'IGUI_AAC_Animal_Stress': 'الإجهاد', 'IGUI_AAC_Animal_Health': 'الصحة', 'IGUI_AAC_Animal_Pregnant': 'حامل', 'IGUI_AAC_Animal_Milk': 'حليب'},
    'CA': {'IGUI_AAC_Animal_Stress': 'Estrès', 'IGUI_AAC_Animal_Health': 'Salut', 'IGUI_AAC_Animal_Pregnant': 'Gestació', 'IGUI_AAC_Animal_Milk': 'Llet'},
    'CH': {'IGUI_AAC_Animal_Stress': '壓力', 'IGUI_AAC_Animal_Health': '健康', 'IGUI_AAC_Animal_Pregnant': '懷孕', 'IGUI_AAC_Animal_Milk': '乳'},
    'CN': {'IGUI_AAC_Animal_Stress': '压力', 'IGUI_AAC_Animal_Health': '健康', 'IGUI_AAC_Animal_Pregnant': '怀孕', 'IGUI_AAC_Animal_Milk': '牛奶'},
    'CS': {'IGUI_AAC_Animal_Stress': 'Stres', 'IGUI_AAC_Animal_Health': 'Zdraví', 'IGUI_AAC_Animal_Pregnant': 'Březí', 'IGUI_AAC_Animal_Milk': 'Mléko'},
    'DA': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Sundhed', 'IGUI_AAC_Animal_Pregnant': 'Drægtighed', 'IGUI_AAC_Animal_Milk': 'Mælk'},
    'DE': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Gesundheit', 'IGUI_AAC_Animal_Pregnant': 'Trächtigkeit', 'IGUI_AAC_Animal_Milk': 'Milch'},
    'EN': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Health', 'IGUI_AAC_Animal_Pregnant': 'Pregnant', 'IGUI_AAC_Animal_Milk': 'Milk'},
    'ES': {'IGUI_AAC_Animal_Stress': 'Estrés', 'IGUI_AAC_Animal_Health': 'Salud', 'IGUI_AAC_Animal_Pregnant': 'Embarazo', 'IGUI_AAC_Animal_Milk': 'Leche'},
    'FI': {'IGUI_AAC_Animal_Stress': 'Stressi', 'IGUI_AAC_Animal_Health': 'Terveys', 'IGUI_AAC_Animal_Pregnant': 'Raskaana', 'IGUI_AAC_Animal_Milk': 'Maito'},
    'FR': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Santé', 'IGUI_AAC_Animal_Pregnant': 'Gestation', 'IGUI_AAC_Animal_Milk': 'Lait'},
    'HU': {'IGUI_AAC_Animal_Stress': 'Stressz', 'IGUI_AAC_Animal_Health': 'Egészség', 'IGUI_AAC_Animal_Pregnant': 'Terhes', 'IGUI_AAC_Animal_Milk': 'Tej'},
    'ID': {'IGUI_AAC_Animal_Stress': 'Stres', 'IGUI_AAC_Animal_Health': 'Kesehatan', 'IGUI_AAC_Animal_Pregnant': 'Hamil', 'IGUI_AAC_Animal_Milk': 'Susu'},
    'IT': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Salute', 'IGUI_AAC_Animal_Pregnant': 'Incinta', 'IGUI_AAC_Animal_Milk': 'Latte'},
    'JP': {'IGUI_AAC_Animal_Stress': 'ストレス', 'IGUI_AAC_Animal_Health': '健康', 'IGUI_AAC_Animal_Pregnant': '妊娠', 'IGUI_AAC_Animal_Milk': '乳'},
    'KO': {'IGUI_AAC_Animal_Stress': '스트레스', 'IGUI_AAC_Animal_Health': '건강', 'IGUI_AAC_Animal_Pregnant': '임신', 'IGUI_AAC_Animal_Milk': '우유'},
    'NL': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Gezondheid', 'IGUI_AAC_Animal_Pregnant': 'Zwanger', 'IGUI_AAC_Animal_Milk': 'Melk'},
    'NO': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Helse', 'IGUI_AAC_Animal_Pregnant': 'Gravid', 'IGUI_AAC_Animal_Milk': 'Melk'},
    'PH': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Kalusugan', 'IGUI_AAC_Animal_Pregnant': 'Buntis', 'IGUI_AAC_Animal_Milk': 'Gatas'},
    'PL': {'IGUI_AAC_Animal_Stress': 'Stres', 'IGUI_AAC_Animal_Health': 'Zdrowie', 'IGUI_AAC_Animal_Pregnant': 'Ciąża', 'IGUI_AAC_Animal_Milk': 'Mleko'},
    'PT': {'IGUI_AAC_Animal_Stress': 'Stress', 'IGUI_AAC_Animal_Health': 'Saúde', 'IGUI_AAC_Animal_Pregnant': 'Grávida', 'IGUI_AAC_Animal_Milk': 'Leite'},
    'PTBR': {'IGUI_AAC_Animal_Stress': 'Estresse', 'IGUI_AAC_Animal_Health': 'Saúde', 'IGUI_AAC_Animal_Pregnant': 'Grávida', 'IGUI_AAC_Animal_Milk': 'Leite'},
    'RO': {'IGUI_AAC_Animal_Stress': 'Stres', 'IGUI_AAC_Animal_Health': 'Sănătate', 'IGUI_AAC_Animal_Pregnant': 'Gestantă', 'IGUI_AAC_Animal_Milk': 'Lapte'},
    'RU': {'IGUI_AAC_Animal_Stress': 'Стресс', 'IGUI_AAC_Animal_Health': 'Здоровье', 'IGUI_AAC_Animal_Pregnant': 'Беременность', 'IGUI_AAC_Animal_Milk': 'Молоко'},
    'TH': {'IGUI_AAC_Animal_Stress': 'ความเครียด', 'IGUI_AAC_Animal_Health': 'สุขภาพ', 'IGUI_AAC_Animal_Pregnant': 'ตั้งครรภ์', 'IGUI_AAC_Animal_Milk': 'น้ำนม'},
    'TR': {'IGUI_AAC_Animal_Stress': 'Stres', 'IGUI_AAC_Animal_Health': 'Sağlık', 'IGUI_AAC_Animal_Pregnant': 'Hamile', 'IGUI_AAC_Animal_Milk': 'Süt'},
    'UA': {'IGUI_AAC_Animal_Stress': 'Стрес', 'IGUI_AAC_Animal_Health': 'Здоров\'я', 'IGUI_AAC_Animal_Pregnant': 'Вагітність', 'IGUI_AAC_Animal_Milk': 'Молоко'}
}
keys = ['IGUI_AAC_Animal_Stress', 'IGUI_AAC_Animal_Health', 'IGUI_AAC_Animal_Pregnant', 'IGUI_AAC_Animal_Milk']
for lang_dir in sorted(root.iterdir()):
    if not lang_dir.is_dir():
        continue
    path = lang_dir / 'IG_UI.json'
    if not path.exists():
        print('skip missing', path)
        continue
    with path.open('r', encoding='utf-8') as f:
        data = json.load(f)
    changed = False
    for k in keys:
        if k not in data:
            data[k] = translations.get(lang_dir.name, translations['EN'])[k]
            changed = True
    if changed:
        with path.open('w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
            f.write('\n')
        print('updated', path)
