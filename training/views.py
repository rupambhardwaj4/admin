from rest_framework import viewsets
from .models import TrainingProgram
from .serializers import TrainingProgramSerializer

class TrainingProgramViewSet(viewsets.ModelViewSet):
    queryset = TrainingProgram.objects.all()
    serializer_class = TrainingProgramSerializer