<div dir="rtl">

# 🛍️ ShopZone

> تطبيق تسوق ذكي مبني بـ Flutter مع دعم كامل للعمل بدون إنترنت

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/State-Provider-6C63FF?style=flat)
![API](https://img.shields.io/badge/API-dummyjson.com-555?style=flat)

---

## 📖 نظرة عامة

**ShopZone** تطبيق موبايل متكامل مبني بإطار عمل Flutter، يعرض منتجات حقيقية مجلوبة من واجهة برمجية عامة ([dummyjson.com](https://dummyjson.com/products)). يدعم التطبيق حفظ المفضلة بشكل دائم، والعمل بدون اتصال بالإنترنت من خلال نظام تخزين مؤقت محلي.

تم بناء التطبيق كجزء من تكليف مادة **Mobile Applications**، ويغطي المتطلبات التالية:

- ✅ جلب البيانات من الإنترنت عبر REST API بصيغة JSON
- ✅ حفظ المفضلة وإبقاؤها بعد إغلاق التطبيق وإعادة فتحه
- ✅ دعم وضع Offline بعرض البيانات المحفوظة مسبقاً عند انقطاع الإنترنت
- ✅ واجهة مستخدم احترافية مع تأثيرات تحميل (Shimmer) وبنر Offline

---

## ✨ المميزات

| الميزة | الحالة | الوصف |
|--------|--------|-------|
| جلب المنتجات من API | ✅ مكتمل | يجلب 30 منتجاً من dummyjson.com مع صور وتفاصيل كاملة |
| وضع Offline | ✅ مكتمل | عند انقطاع الإنترنت تظهر البيانات المحفوظة مسبقاً |
| بنر الحالة | ✅ مكتمل | يعرض بنر أصفر مع تاريخ آخر تحديث عند العمل بدون إنترنت |
| المفضلة الدائمة | ✅ مكتمل | تُحفظ في SharedPreferences وتبقى بعد إغلاق التطبيق |
| تفاصيل المنتج | ✅ مكتمل | شاشة تعرض صوراً متعددة ونسبة الخصم والتقييم والمخزون |
| البحث | ✅ مكتمل | يعمل أونلاين وأوفلاين بالفلترة على البيانات المحلية |
| Shimmer Loading | ✅ مكتمل | هيكل تحميل جذاب أثناء جلب البيانات |
| عداد المفضلة | ✅ مكتمل | Badge يعرض عدد المنتجات المفضلة في شريط التنقل |

---

## 📱 شاشات التطبيق

### ١. شاشة المنتجات (Home)
- عرض شبكي للمنتجات (2 عمود) مع صور من الإنترنت
- شريط بحث يعمل مع الإنترنت ومع الكاش
- Shimmer loading أثناء الانتظار
- بنر تحذيري عند الدخول بدون إنترنت
- زر ❤️ على كل كارد لإضافة/إزالة المفضلة فوراً

### ٢. شاشة المفضلة (Favorites)
- عرض شبكي لجميع المنتجات المضافة إلى المفضلة
- تُحدَّث تلقائياً عند الإضافة أو الحذف من أي شاشة
- رسالة توجيهية تظهر عند كون المفضلة فارغة

### ٣. شاشة تفاصيل المنتج (Detail)
- معرض صور قابل للتمرير (PageView) مع نقاط تدل على الصفحة الحالية
- اسم المنتج والعلامة التجارية والفئة
- السعر مع badge الخصم ومؤشر التقييم بالنجوم
- حالة المخزون (متوفر / كمية محدودة)
- وصف كامل للمنتج
- زر إضافة/إزالة من المفضلة

---

## 📡 آلية العمل Offline

**عند أول تشغيل مع توفر الإنترنت:**
1. يتصل التطبيق بـ dummyjson.com ويجلب المنتجات
2. يُخزِّن البيانات في SharedPreferences بصيغة JSON
3. يحفظ تاريخ ووقت آخر تحديث

**عند فتح التطبيق بدون إنترنت:**
1. يحاول الاتصال بالـ API — يفشل بسبب انقطاع الإنترنت
2. يقرأ البيانات المحفوظة من SharedPreferences
3. يعرض البنر الأصفر مع تاريخ آخر تحديث للكاش

---

## 🗂️ هيكل الملفات

```
lib/
├── main.dart                          # نقطة البداية + Bottom Navigation
├── models/
│   └── product.dart                   # نموذج بيانات المنتج (fromJson / toJson)
├── services/
│   ├── product_service.dart           # جلب البيانات من API + Cache
│   └── favorites_service.dart         # إدارة المفضلة عبر SharedPreferences
├── providers/
│   └── products_provider.dart         # إدارة الحالة (State) بـ Provider
├── screens/
│   ├── home_screen.dart               # شاشة المنتجات + البحث
│   ├── favorites_screen.dart          # شاشة المفضلة
│   └── product_detail_screen.dart     # شاشة تفاصيل المنتج
└── widgets/
    ├── product_card.dart              # كارد عرض المنتج مع زر المفضلة
    ├── shimmer_grid.dart              # هيكل تحميل Shimmer
    └── offline_banner.dart            # بنر حالة Offline
```

---

## 📦 المكتبات المستخدمة

| الحزمة | الاستخدام | الإصدار |
|--------|-----------|---------|
| `http` | جلب البيانات من REST API | ^1.2.0 |
| `shared_preferences` | حفظ المفضلة والكاش محلياً | ^2.2.2 |
| `provider` | إدارة حالة التطبيق | ^6.1.1 |
| `cached_network_image` | تحميل وتخزين الصور | ^3.3.1 |
| `connectivity_plus` | التحقق من حالة الإنترنت | ^5.0.2 |
| `shimmer` | تأثير تحميل Shimmer | ^3.0.0 |

---

## 🚀 تشغيل التطبيق

### المتطلبات
- Flutter SDK الإصدار 3.0.0 أو أحدث
- Dart SDK الإصدار 3.0.0 أو أحدث
- Android Studio أو VS Code مع إضافة Flutter
- محاكي Android/iOS أو جهاز حقيقي

### خطوات التشغيل

```bash
# ١. استنساخ المشروع أو فك ضغط الملف
cd flutter_products_app

# ٢. تثبيت المكتبات
flutter pub get

# ٣. تشغيل التطبيق
flutter run
```

---

## 🌐 واجهة API المستخدمة

**المصدر:** [dummyjson.com/products](https://dummyjson.com/products)

| المسار | الوظيفة | المثال |
|--------|---------|--------|
| `/products` | جلب قائمة المنتجات | `?limit=30&skip=0` |
| `/products/search` | البحث في المنتجات | `?q=phone` |

## المخرجات 


<p align="center">
    <img width="300"  alt="fav" src="https://github.com/user-attachments/assets/f8af122a-af5a-43f1-a1f8-a46133d3fcb3" />
<img width="1211" height="2474" alt="fav2" src="https://github.com/user-attachments/assets/5ec5f039-d1e0-4136-8f97-010b9ddb6b1a" />
    </p>

  <p align="center">
<img width="300" alt="hmhm" src="https://github.com/user-attachments/assets/e03e7dde-5b69-4098-aa78-901e9b4f47a6" />
<img width="300"  alt="hm" src="https://github.com/user-attachments/assets/95a2ad34-d9cb-4f37-b3d3-e677a84c93f8" />

</p>


---

<p align="center">
تم تطوير هذا التطبيق كجزء من متطلبات مادة تطبيقات الموبايل<br/>
ShopZone © 2025 — Flutter + dummyjson.com
</p>

</div>
