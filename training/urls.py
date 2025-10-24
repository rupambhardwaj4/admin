from rest_framework.routers import DefaultRouter
from .views import TrainingProgramViewSet

router = DefaultRouter()
router.register(r'training-programs', TrainingProgramViewSet)

urlpatterns = router.urls